#############################################################
#
# runit
#
#############################################################
RUNIT_VERSION          = 2.1.1
RUNIT_SOURCE           = runit-$(RUNIT_VERSION).tar.gz
RUNIT_SITE             = http://smarden.org/runit/
RUNIT_SLASHPACKAGE_DIR = $(@D)/admin/runit-$(RUNIT_VERSION)

TARGET_LDFLAGS += -static

# Override Busybox implementations if Busybox is enabled.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
RUNIT_DEPENDENCIES = busybox
endif

define RUNIT_EXTRACT_CMDS
	($(ZCAT) $(DL_DIR)/$(RUNIT_SOURCE) | $(TAR) -C $(@D) $(TAR_OPTIONS) -)
endef

define RUNIT_BUILD_CMDS
	echo '$(TARGET_CC) $(TARGET_CFLAGS)' > $(RUNIT_SLASHPACKAGE_DIR)/src/conf-cc
	echo '$(TARGET_CC) $(TARGET_LDFLAGS)' > $(RUNIT_SLASHPACKAGE_DIR)/src/conf-ld
	(cd $(RUNIT_SLASHPACKAGE_DIR) && package/compile)
endef

define RUNIT_INSTALL_INIT_HOOK
	ln -sf ../sbin/runit-init $(TARGET_DIR)/sbin/init
	ln -sf ../etc/sv $(TARGET_DIR)/service
endef

define RUNIT_INSTALL_TARGET_CMDS
	for x in chpst runit runit-init runsv runsvchdir runsvdir sv svlogd utmpset; do \
		install -D -m 0755 $(RUNIT_SLASHPACKAGE_DIR)/command/$$x $(TARGET_DIR)/sbin/$$x || exit 1; \
	done
endef

RUNIT_POST_INSTALL_TARGET_HOOKS += \
	RUNIT_INSTALL_INIT_HOOK

define RUNIT_UNINSTALL_TARGET_CMDS
	for x in chpst runit runit-init runsv runsvchdir runsvdir sv svlogd utmpset; do \
		rm -f $(TARGET_DIR)/sbin/$$x || exit 1; \
	done
endef

define RUNIT_CLEAN_CMDS
	for x in chpst runit runit-init runsv runsvchdir runsvdir sv svlogd utmpset; do \
		rm -f $(RUNIT_SLASHPACKAGE_DIR)/command/$$x; \
	done
endef

$(eval $(generic-package))
