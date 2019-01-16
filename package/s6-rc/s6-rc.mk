################################################################################
#
# s6-rc
#
################################################################################

S6_RC_VERSION = 0.4.0.1
S6_RC_SITE = http://skarnet.org/software/s6-rc
S6_RC_LICENSE = ISC
S6_RC_LICENSE_FILES = COPYING
S6_RC_INSTALL_STAGING = YES
S6_RC_DEPENDENCIES = s6

ifeq ($(BR2_INIT_S6),y)
# Needs s6-rc-compile to create initial rc db, also
# build after s6-linux-init to rewrite rc.init for run
# s6-rc services.
S6_RC_DEPENDENCIES += host-s6-rc s6-linux-init
endif

S6_RC_CONF_OPTS = \
	--prefix=/usr \
	--with-sysdeps=$(STAGING_DIR)/usr/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/usr/include \
	--with-dynlib=$(STAGING_DIR)/usr/lib \
	--with-lib=$(STAGING_DIR)/usr/lib/execline \
	--with-lib=$(STAGING_DIR)/usr/lib/s6 \
	--with-lib=$(STAGING_DIR)/usr/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

define S6_RC_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_RC_CONF_OPTS))
endef

define S6_RC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_RC_REMOVE_STATIC_LIB_DIR
	rm -rf $(TARGET_DIR)/usr/lib/s6-rc
endef

S6_RC_POST_INSTALL_TARGET_HOOKS += S6_RC_REMOVE_STATIC_LIB_DIR

define S6_RC_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define S6_RC_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

ifeq ($(BR2_INIT_S6),y)

define S6_RC_PREPARE_INIT_RC
	mkdir -p $(TARGET_DIR)/etc/s6-rc/service/default
	echo bundle > $(TARGET_DIR)/etc/s6-rc/service/default/type
	touch $(TARGET_DIR)/etc/s6-rc/service/default/contents

	mkdir -p $(TARGET_DIR)/etc/s6-rc/compiled-initial
	ln -sf compiled-initial $(TARGET_DIR)/etc/s6-rc/compiled

	$(INSTALL) -m 0755 $(S6_RC_PKGDIR)/rc.init $(TARGET_DIR)/etc/rc.init
	$(INSTALL) -m 0755 $(S6_RC_PKGDIR)/rc.shutdown $(TARGET_DIR)/etc/rc.shutdown
endef
S6_RC_POST_INSTALL_TARGET_HOOKS += S6_RC_PREPARE_INIT_RC

define S6_RC_FINALIZE_INIT_RC
	rm -rf $(TARGET_DIR)/etc/s6-rc/compiled-initial
	$(HOST_DIR)/bin/s6-rc-compile -v 1 \
		$(TARGET_DIR)/etc/s6-rc/compiled-initial \
		$(TARGET_DIR)/etc/s6-rc/service
endef
S6_RC_ROOTFS_PRE_CMD_HOOKS += S6_RC_FINALIZE_INIT_RC

endif # BR2_INIT_S6

HOST_S6_RC_DEPENDENCIES = host-s6

HOST_S6_RC_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--libexecdir=/usr/libexec \
	--with-sysdeps=$(HOST_DIR)/lib/skalibs/sysdeps \
	--with-include=$(HOST_DIR)/include \
	--with-dynlib=$(HOST_DIR)/lib \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_S6_RC_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_S6_RC_CONF_OPTS))
endef

define HOST_S6_RC_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_S6_RC_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install-dynlib install-bin
	rm -f $(HOST_DIR)/bin/s6-rc-dryrun
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
