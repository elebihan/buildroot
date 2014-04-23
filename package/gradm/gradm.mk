#############################################################
#
# gradm
#
#############################################################

GRADM_VERSION = 3.0-201401291757
GRADM_SOURCE = gradm-$(GRADM_VERSION).tar.gz
GRADM_SITE = http://grsecurity.net/stable/
GRADM_LICENSE = GPLv2
GRADM_DEPENDENCIES = host-flex host-bison

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
GRADM_DEPENDENCIES += linux-pam
define GRADM_INSTALL_GRADM_PAM
	$(INSTALL) -D -m 4755 $(@D)/gradm_pam $(TARGET_DIR)/sbin/
endef
GRADM_BUILD_TYPE = all
else
GRADM_BUILD_TYPE = nopam
endif

define GRADM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS))" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		PAM_INCLUDE_DIR="$(STAGING_DIR)/usr/include" \
		-C $(@D) $(GRADM_BUILD_TYPE)
endef

define GRADM_BUILD_CLEAN
	$(TARGET_MAKE_ENV) $(MAKE) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D) clean
endef

define GRADM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/gradm $(TARGET_DIR)/sbin/
	$(INSTALL) -D -m 0700 $(@D)/grlearn $(TARGET_DIR)/sbin/
	$(INSTALL) -d -m 700 $(TARGET_DIR)/etc/grsec/
	$(INSTALL) -D -m 0700 $(@D)/policy $(TARGET_DIR)/etc/grsec/
	$(INSTALL) -D -m 0700 $(@D)/learn_config $(TARGET_DIR)/etc/grsec/
	$(GRADM_INSTALL_GRADM_PAM)
endef

define GRADM_UNINSTALL_TARGET_CMDS
	$(RM) $(TARGET_DIR)/sbin/gradm
	$(RM) $(TARGET_DIR)/sbin/grlearn
	$(RM) -r $(TARGET_DIR)/etc/grsec
endef

define GRADM_INSTALL_UDEV_RULES
	$(INSTALL) -d -m 755 $(TARGET_DIR)/etc/udev/rules.d
	$(INSTALL) -D -m 0644 package/gradm/80-grsec.rules \
		$(TARGET_DIR)/etc/udev/rules.d
endef

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
GRADM_POST_INSTALL_TARGET_HOOKS += GRADM_INSTALL_UDEV_RULES
endif

$(eval $(generic-package))
