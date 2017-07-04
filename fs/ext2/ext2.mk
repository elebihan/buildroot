################################################################################
#
# Build the ext2 root filesystem image
#
################################################################################

# qstrip results in stripping consecutive spaces into a single one. So the
# variable is not qstrip-ed to preserve the integrity of the string value.
EXT2_LABEL := $(subst ",,$(BR2_TARGET_ROOTFS_EXT2_LABEL))
#" Syntax highlighting... :-/ )

EXT2_OPTS = \
	-G $(BR2_TARGET_ROOTFS_EXT2_GEN) \
	-R $(BR2_TARGET_ROOTFS_EXT2_REV) \
	-B 1024 \
	-b $(BR2_TARGET_ROOTFS_EXT2_BLOCKS) \
	-i $(BR2_TARGET_ROOTFS_EXT2_INODES) \
	-I $(BR2_TARGET_ROOTFS_EXT2_EXTRA_INODES) \
	-r $(BR2_TARGET_ROOTFS_EXT2_RESBLKS) \
	-l "$(EXT2_LABEL)"

ROOTFS_EXT2_DEPENDENCIES = host-mke2img

define ROOTFS_EXT2_CMD
	PATH=$(BR_PATH) mke2img -d $(TARGET_DIR) $(EXT2_OPTS) -o $@
endef

rootfs-ext2-symlink:
	ln -sf rootfs.ext2$(ROOTFS_EXT2_COMPRESS_EXT) $(BINARIES_DIR)/rootfs.ext$(BR2_TARGET_ROOTFS_EXT2_GEN)$(ROOTFS_EXT2_COMPRESS_EXT)

.PHONY: rootfs-ext2-symlink

ifneq ($(BR2_TARGET_ROOTFS_EXT2_GEN),2)
ROOTFS_EXT2_POST_TARGETS += rootfs-ext2-symlink
endif

$(eval $(call ROOTFS_TARGET,ext2))
