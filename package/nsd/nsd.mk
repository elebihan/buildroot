################################################################################
#
# nsd
#
################################################################################

NSD_VERSION = 4.1.0
NSD_SITE = http://www.nlnetlabs.nl/downloads/nsd/
NSD_LICENSE = BSD-3c
NSD_LICENSE_FILES = LICENSE

NSD_CONF_OPT = \
	--with-dbfile=/var/db/nsd/nsd.db \
	--datarootdir=/usr/share

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
NSD_CONF_OPT += --with-pidfile=/run/nsd/nsd.pid
else
NSD_CONF_OPT += --with-pidfile=/var/run/nsd.pid
endif

ifeq ($(BR2_PACKAGE_LIBEVENT),y)
NSD_CONF_OPT += --with-libevent=$(STAGING_DIR)/usr
NSD_DEPENDENCIES += libevent
else
NSD_CONF_OPT += --with-libevent=no
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
NSD_CONF_OPT += --with-ssl=$(STAGING_DIR)/usr
NSD_DEPENDENCIES += openssl
else
NSD_CONF_OPT += --with-ssl=no
endif

define NSD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/nsd/S80nsd \
		$(TARGET_DIR)/etc/init.d/S80nsd
endef

define NSD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/nsd/nsd.service \
		$(TARGET_DIR)/lib/systemd/system/nsd.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -sf ../../../../lib/systemd/system/nsd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/nsd.service

	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/lib/tmpfiles.d
	echo "d /run/nsd 0755 nsd nsd -" > $(TARGET_DIR)/usr/lib/tmpfiles.d/nsd.conf
endef

define NSD_USERS
	nsd -1 nsd -1 * /var/db/nsd - - Domain Name Server
endef

define NSD_INSTALL_DEFAULT_CONF
	$(RM) $(TARGET_DIR)/etc/nsd/nsd.conf.sample
	$(INSTALL) -D -m 644 package/nsd/nsd.conf \
		$(TARGET_DIR)/etc/nsd/nsd.conf
endef

NSD_POST_INSTALL_TARGET_HOOKS += NSD_INSTALL_DEFAULT_CONF

$(eval $(autotools-package))
