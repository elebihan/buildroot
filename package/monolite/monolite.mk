################################################################################
#
# monolite
#
################################################################################

MONOLITE_VERSION = 1050200001
MONOLITE_SITE = http://download.mono-project.com/monolite/
MONOLITE_SOURCE = monolite-$(MONOLITE_VERSION)-latest.tar.gz
MONOLITE_LICENSE = LGPL-2.0 or commercial

define HOST_MONOLITE_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/lib/monolite/$(MONOLITE_VERSION)
	cp -r $(@D)/* $(HOST_DIR)/lib/monolite/$(MONOLITE_VERSION)
endef

$(eval $(host-generic-package))
