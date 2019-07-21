################################################################################
#
# cargo
#
################################################################################

define HOST_CARGO_INSTALL_CONFIG
	$(INSTALL) -D package/cargo/config.in \
		$(HOST_DIR)/share/cargo/config
	$(SED) 's/@RUSTC_TARGET_NAME@/$(RUSTC_TARGET_NAME)/' \
		$(HOST_DIR)/share/cargo/config
	$(SED) 's/@CROSS_PREFIX@/$(notdir $(TARGET_CROSS))/' \
		$(HOST_DIR)/share/cargo/config
endef

$(eval $(host-virtual-package))
