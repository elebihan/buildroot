################################################################################
#
# cargo-bin
#
################################################################################

CARGO_BIN_VERSION = 0.33.0
CARGO_BIN_SITE = https://static.rust-lang.org/dist
CARGO_BIN_SOURCE = cargo-$(CARGO_BIN_VERSION)-$(RUSTC_HOST_NAME).tar.xz
CARGO_BIN_LICENSE = Apache-2.0 or MIT
CARGO_BIN_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT
CARGO_BIN_PROVIDES = host-cargo

ifeq ($(BR2_PACKAGE_HOST_CARGO_BIN),y)
define HOST_CARGO_BIN_INSTALL_CMDS
	$(@D)/install.sh --prefix=$(HOST_DIR) --disable-ldconfig
endef
HOST_CARGO_BIN_POST_INSTALL_HOOKS += HOST_CARGO_INSTALL_CONFIG
endif

$(eval $(host-generic-package))
