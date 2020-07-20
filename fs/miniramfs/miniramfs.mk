################################################################################
#
# Build a minimal companion ramfs
#
################################################################################

ROOTFS_MINIRAMFS_OVERLAY = $(call qstrip,$(BR2_TARGET_ROOTFS_MINIRAMFS_OVERLAY))

ifeq ($(BR2_TARGET_ROOTFS_MINIRAMFS_INITRAMFS),y)
ROOTFS_MINIRAMFS_POST_TARGETS += linux-rebuild-with-initramfs
endif

ROOTFS_MINIRAMFS_DEPENDENCIES = target-finalize busybox

ROOTFS_MINIRAMFS_DIR = $(BUILD_DIR)/miniramfs

ROOTFS_MINIRAMFS_BINS = /bin/busybox

ifeq ($(BR2_PACKAGE_MTD),y)
ROOTFS_MINIRAMFS_DEPENDENCIES += mtd
ROOTFS_MINIRAMFS_BINS += \
	/usr/sbin/ubiattach \
	/usr/sbin/ubidetach \

endif

ifeq ($(BR2_PACKAGE_LVM2),y)
ROOTFS_MINIRAMFS_DEPENDENCIES += lvm2
ROOTFS_MINIRAMFS_BINS += /usr/sbin/dmsetup
endif

ifeq ($(BR2_PACKAGE_GPTFDISK_SGDISK),y)
ROOTFS_MINIRAMFS_DEPENDENCIES += gptfdisk
ROOTFS_MINIRAMFS_BINS += /usr/sbin/sgdisk
endif

ifeq ($(BR2_ARCH_IS_64),y)
ROOTFS_MINIRAMFS_ARCH_LIBDIR = lib64
else
ROOTFS_MINIRAMFS_ARCH_LIBDIR = lib32
endif

define ROOTFS_MINIRAMFS_BUILD_SKELETON
	rm -rf $(ROOTFS_MINIRAMFS_DIR)
	for d in bin dev etc lib mnt proc run sbin sys tmp; do \
		mkdir -p $(ROOTFS_MINIRAMFS_DIR)/fs/$$d; \
	done

	for f in $(ROOTFS_MINIRAMFS_BINS); do \
		cp -a $(TARGET_DIR)/$$f $(ROOTFS_MINIRAMFS_DIR)/fs/bin; \
	done

	for f in $$(find $(TARGET_DIR)/bin -type l -lname busybox -printf "%f\n"); do \
		ln -sf busybox $(ROOTFS_MINIRAMFS_DIR)/fs/bin/$$f; \
	done

	for f in switch_root mdev blkid losetup reboot; do \
		ln -sf ../bin/busybox $(ROOTFS_MINIRAMFS_DIR)/fs/sbin/$$f; \
	done

	ln -sf lib $(ROOTFS_MINIRAMFS_DIR)/fs/$(ROOTFS_MINIRAMFS_ARCH_LIBDIR)

	$(INSTALL) -m 0755 fs/miniramfs/init $(ROOTFS_MINIRAMFS_DIR)/fs/init
	$(INSTALL) -m 0644 fs/miniramfs/fstab $(ROOTFS_MINIRAMFS_DIR)/fs/etc

	ln -sf /bin/sh $(ROOTFS_MINIRAMFS_DIR)/fs/sbin/init

	find $(TARGET_DIR)/lib \( -name '*.so' -o -name '*.so.*' \) \
		| while read f; do \
			d=$$(dirname $$f | sed -e 's!$(TARGET_DIR)!$(ROOTFS_MINIRAMFS_DIR)/fs!g'); \
			mkdir -p $$d; \
			cp -a $$f $$d; \
		done

	find $(TARGET_DIR)/usr/lib \( -name '*.so' -o -name '*.so.*' \) \
		| while read f; do \
			d=$$(dirname $$f | sed -e 's!$(TARGET_DIR)/usr!$(ROOTFS_MINIRAMFS_DIR)/fs!g'); \
			mkdir -p $$d; \
			cp -a $$f $$d; \
		done

	find $(ROOTFS_MINIRAMFS_DIR) -name '*.py' -delete

	find $(ROOTFS_MINIRAMFS_DIR)/fs/bin $(ROOTFS_MINIRAMFS_DIR)/fs/lib \
		\( -type f -o -type l -executable -o -name '*.so*' \) \
		-exec file {} \; \
	| grep -i elf \
	| cut -d: -f1 \
	| xargs objdump -p \
	| awk '/NEEDED /{ print $$2 }' \
	| sort \
	| uniq \
	| while read f; do \
		echo $$f; \
		if [ -L $(ROOTFS_MINIRAMFS_DIR)/fs/lib/$$f ]; then \
			readlink $(ROOTFS_MINIRAMFS_DIR)/fs/lib/$$f; \
		fi; \
	done > $(ROOTFS_MINIRAMFS_DIR)/required-libs-pass1.txt

	find $(ROOTFS_MINIRAMFS_DIR)/fs/lib -name '*.so*' \
	| grep -Ff $(ROOTFS_MINIRAMFS_DIR)/required-libs-pass1.txt \
	| xargs objdump -p \
	| awk '/NEEDED /{ print $$2 }' \
	| sort \
	| uniq \
	| while read f; do \
		echo $$f; \
		if [ -L $(ROOTFS_MINIRAMFS_DIR)/fs/lib/$$f ]; then \
			readlink $(ROOTFS_MINIRAMFS_DIR)/fs/lib/$$f; \
		fi; \
	done > $(ROOTFS_MINIRAMFS_DIR)/required-libs-pass2.txt

	sort $(ROOTFS_MINIRAMFS_DIR)/required-libs-pass*.txt \
	| uniq > $(ROOTFS_MINIRAMFS_DIR)/required-libs.txt

	find $(ROOTFS_MINIRAMFS_DIR)/fs/lib -name '*.so*' \
	| grep -vFf $(ROOTFS_MINIRAMFS_DIR)/required-libs.txt \
	| xargs rm -f

	find $(ROOTFS_MINIRAMFS_DIR)/fs/bin -executable -exec $(STRIPCMD) {} \;
	find $(ROOTFS_MINIRAMFS_DIR)/fs/lib -name '*.so' -exec $(STRIPCMD) {} \;

endef

ifneq ($(ROOTFS_MINIRAMFS_OVERLAY),)
define ROOTFS_MINIRAMFS_COPY_OVERLAY
	@$(call MESSAGE,"Copying MINIRAMFS overlay")
	$(call SYSTEM_RSYNC,$(ROOTFS_MINIRAMFS_OVERLAY),$(ROOTFS_MINIRAMFS_DIR)/fs)
endef
endif

define ROOTFS_MINIRAMFS_BUILD_CPIO
	(cd $(ROOTFS_MINIRAMFS_DIR)/fs && \
		 ((find; echo /dev/console; echo /dev/kmsg) | cpio -oH newc) \
	) > $(BINARIES_DIR)/miniramfs.cpio
endef

define ROOTFS_MINIRAMFS_BUILD_CMDS
	$(ROOTFS_MINIRAMFS_BUILD_SKELETON)
	$(ROOTFS_MINIRAMFS_COPY_OVERLAY)
	$(ROOTFS_MINIRAMFS_BUILD_CPIO)
endef

# The generic fs infrastructure is not very useful here
$(BINARIES_DIR)/miniramfs.cpio: target-finalize $$(ROOTFS_MINIRAMFS_DEPENDENCIES)
	$(ROOTFS_MINIRAMFS_BUILD_CMDS)

rootfs-miniramfs: $(BINARIES_DIR)/miniramfs.cpio $(ROOTFS_MINIRAMFS_POST_TARGETS) linux-rebuild-with-initramfs

rootfs-miniramfs-show-depends:
	@echo $(ROOTFS_MINIRAMFS_DEPENDENCIES)

.PHONY: rootfs-miniramfs rootfs-miniramfs-show-depends

ifeq ($(BR2_TARGET_ROOTFS_MINIRAMFS),y)
TARGETS_ROOTFS += rootfs-miniramfs
endif
