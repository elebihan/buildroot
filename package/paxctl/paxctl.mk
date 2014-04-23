#############################################################
#
# paxctl
#
#############################################################

PAXCTL_VERSION = 0.7
PAXCTL_SOURCE = paxctl-$(PAXCTL_VERSION).tar.bz2
PAXCTL_SITE = http://pax.grsecurity.net
PAXCTL_LICENSE = GPLv2

define PAXCTL_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D) all
endef

define PAXCTL_BUILD_CLEAN
	$(MAKE) CC="$(TARGET_CC)" LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D) clean
endef

define PAXCTL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/paxctl $(TARGET_DIR)/sbin/
endef

define PAXCTL_UNINSTALL_TARGET_CMDS
	$(RM) $(TARGET_DIR)/sbin/paxctl
endef

$(eval $(generic-package))
