################################################################################
#
# unbound
#
################################################################################

UNBOUND_VERSION = 1.4.22
UNBOUND_SITE = http://unbound.net/downloads/
UNBOUND_LICENSE = BSD-3c
UNBOUND_LICENSE_FILES = LICENSE

UNBOUND_DEPENDENCIES = expat

UNBOUND_CONF_OPT = \
	--prefix=/usr \
	--sysconfdir=/etc \
	--disable-rpath \
	--localstatedir=/var \
	--with-libexpat=$(STAGING_DIR)/usr

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
UNBOUND_CONF_OPT += --with-pidfile=/run/unbound.pid
else
UNBOUND_CONF_OPT += --with-pidfile=/var/run/unbound.pid
endif

ifeq ($(BR2_PACKAGE_LIBEVENT),y)
UNBOUND_CONF_OPT += --with-libevent=$(STAGING_DIR)/usr
UNBOUND_DEPENDENCIES += libevent
else
UNBOUND_CONF_OPT += --with-libevent=no
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
UNBOUND_CONF_OPT += --with-ssl=$(STAGING_DIR)/usr
UNBOUND_DEPENDENCIES += openssl
else
UNBOUND_CONF_OPT += --with-ssl=no
endif

define UNBOUND_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/unbound/S80unbound \
		$(TARGET_DIR)/etc/init.d/S80unbound
endef

define UNBOUND_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/unbound/unbound.service \
		$(TARGET_DIR)/lib/systemd/system/unbound.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -sf ../../../../lib/systemd/system/unbound.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/unbound.service
endef

define UNBOUND_USERS
	unbound -1 unbound -1 * - - - DNS Resolver
endef

define UNBOUND_INSTALL_DEFAULT_CONF
	$(INSTALL) -D -m 0644 package/unbound/unbound.conf \
		$(TARGET_DIR)/etc/unbound/unbound.conf
endef

UNBOUND_POST_INSTALL_TARGET_HOOKS += UNBOUND_INSTALL_DEFAULT_CONF

$(eval $(autotools-package))
