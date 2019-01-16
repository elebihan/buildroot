################################################################################
#
# s6-linux-init
#
################################################################################

S6_LINUX_INIT_VERSION = 0.4.0.0
S6_LINUX_INIT_SITE = http://skarnet.org/software/s6-linux-init
S6_LINUX_INIT_LICENSE = ISC
S6_LINUX_INIT_LICENSE_FILES = COPYING
S6_LINUX_INIT_DEPENDENCIES = s6 s6-linux-utils s6-portable-utils host-s6-linux-init

S6_LINUX_INIT_CONF_OPTS = \
	--prefix=/usr \
	--with-sysdeps=$(STAGING_DIR)/usr/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/usr/include \
	--with-dynlib=$(STAGING_DIR)/usr/lib \
	--with-lib=$(STAGING_DIR)/usr/lib/execline \
	--with-lib=$(STAGING_DIR)/usr/lib/s6 \
	--with-lib=$(STAGING_DIR)/usr/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

define S6_LINUX_INIT_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_LINUX_INIT_CONF_OPTS))
endef

define S6_LINUX_INIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_LINUX_INIT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

ifeq ($(BR2_INIT_S6),y)

# Don't let Busybox to install it's own tools like poweroff, reboot, halt, etc
S6_LINUX_INIT_DEPENDENCIES += $(if $(BR2_PACKAGE_BUSYBOX),busybox)

S6_LINUX_INIT_MAKER_OPTS = -b /usr/bin -c /etc/s6

ifeq ($(BR2_ROOTFS_DEVICE_CREATION_STATIC),y)
S6_LINUX_INIT_MAKER_OPTS += -d 0
else
S6_LINUX_INIT_MAKER_OPTS += $(if $(BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_DEVTMPFS),,-d 1)
endif

ifeq ($(BR2_TARGET_GENERIC_GETTY),y)
S6_LINUX_INIT_MAKER_OPTS += -G "/sbin/getty -L \
			  $(SYSTEM_GETTY_OPTIONS) \
			  $(SYSTEM_GETTY_PORT) \
			  $(SYSTEM_GETTY_BAUDRATE) \
			  $(SYSTEM_GETTY_TERM)"
endif

define S6_LINUX_INIT_INSTALL_INIT
	ln -sf ../etc/s6/init $(TARGET_DIR)/sbin/init

	ln -sf /usr/bin/s6-reboot $(TARGET_DIR)/sbin/reboot
	ln -sf /usr/bin/s6-poweroff $(TARGET_DIR)/sbin/poweroff
	ln -sf /usr/bin/s6-halt $(TARGET_DIR)/sbin/halt

	echo "#! /usr/bin/execlineb -P" > $(@D)/rc.init
	$(INSTALL) -m 0755 $(@D)/rc.init $(TARGET_DIR)/etc/rc.init
	echo "#! /usr/bin/execlineb -P" > $(@D)/rc.shutdown
	$(INSTALL) -m 0755 $(@D)/rc.shutdown $(TARGET_DIR)/etc/rc.shutdown

	rm -rf $(TARGET_DIR)/etc/s6
	$(HOST_DIR)/bin/s6-linux-init-maker $(S6_LINUX_INIT_MAKER_OPTS) $(TARGET_DIR)/etc/s6
endef
S6_LINUX_INIT_POST_INSTALL_TARGET_HOOKS += S6_LINUX_INIT_INSTALL_INIT

endif # BR2_INIT_S6

HOST_S6_LINUX_INIT_DEPENDENCIES = host-s6

HOST_S6_LINUX_INIT_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--with-sysdeps=$(HOST_DIR)/usr/lib/skalibs/sysdeps \
	--with-include=$(HOST_DIR)/usr/include \
	--with-dynlib=$(HOST_DIR)/usr/lib \
	--with-lib=$(HOST_DIR)/usr/lib/execline \
	--with-lib=$(HOST_DIR)/usr/lib/s6 \
	--with-lib=$(HOST_DIR)/usr/lib/skalibs \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_S6_LINUX_INIT_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_S6_LINUX_INIT_CONF_OPTS))
endef

define HOST_S6_LINUX_INIT_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_S6_LINUX_INIT_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
