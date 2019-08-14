################################################################################
#
# dub-bin
#
################################################################################

DUB_BIN_VERSION = 1.16.0
DUB_BIN_SITE = https://github.com/dlang/dub/releases/download/v$(DUB_BIN_VERSION)
DUB_BIN_SOURCE = dub-v$(DUB_BIN_VERSION)-linux-$(HOSTARCH).tar.gz
DUB_BIN_LICENSE = MIT

define HOST_DUB_BIN_EXTRACT_CMDS
	$(INSTALL) -d $(@D)
	$(call suitable-extractor,$(HOST_DUB_BIN_SOURCE)) \
		$(HOST_DUB_BIN_DL_DIR)/$(HOST_DUB_BIN_SOURCE) | \
	$(TAR) --strip-components=0 -C $(@D) $(TAR_OPTIONS) -
endef

define HOST_DUB_BIN_INSTALL_CMDS
	$(INSTALL) -m 0755 $(@D)/dub $(HOST_DIR)/usr/bin/dub
endef

$(eval $(host-generic-package))
