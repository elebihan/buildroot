#############################################################
#
# ipsvd
#
#############################################################
IPSVD_VERSION          = 1.0.0
IPSVD_SOURCE           = ipsvd-$(IPSVD_VERSION).tar.gz
IPSVD_SITE             = http://smarden.org/ipsvd/
IPSVD_SLASHPACKAGE_DIR = $(@D)/net/ipsvd-$(IPSVD_VERSION)

TARGET_LDFLAGS += -static

# Override Busybox implementations if Busybox is enabled.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
IPSVD_DEPENDENCIES = busybox
endif

define IPSVD_EXTRACT_CMDS
	($(ZCAT) $(DL_DIR)/$(IPSVD_SOURCE) | $(TAR) -C $(@D) $(TAR_OPTIONS) -)
endef

define IPSVD_BUILD_CMDS
	echo '$(TARGET_CC) $(TARGET_CFLAGS)' > $(IPSVD_SLASHPACKAGE_DIR)/src/conf-cc
	echo '$(TARGET_CC) $(TARGET_LDFLAGS)' > $(IPSVD_SLASHPACKAGE_DIR)/src/conf-ld
	(cd $(IPSVD_SLASHPACKAGE_DIR) && package/compile)
endef

define IPSVD_INSTALL_TARGET_CMDS
	for x in ipsvd-cdb tcpsvd udpsvd; do \
		install -D -m 0755 $(IPSVD_SLASHPACKAGE_DIR)/command/$$x $(TARGET_DIR)/sbin/$$x || exit 1; \
	done
endef

define IPSVD_UNINSTALL_TARGET_CMDS
	for x in ipsvd-cdb tcpsvd udpsvd; do \
		rm -f $(TARGET_DIR)/sbin/$$x || exit 1; \
	done
endef

define IPSVD_CLEAN_CMDS
	for x in ipsvd-cdb tcpsvd udpsvd; do \
		rm -f $(IPSVD_SLASHPACKAGE_DIR)/command/$$x; \
	done
endef

$(eval $(generic-package))
