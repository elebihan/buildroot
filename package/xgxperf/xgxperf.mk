################################################################################
#
# xgxperf
#
################################################################################

XGXPERF_VERSION = b9d5d72bd8f2b98ff3d9e4365caffd2b4f388868
XGXPERF_SITE = $(call github,prabindh,xgxperf,$(XGXPERF_VERSION))
XGXPERF_DEPENDENCIES = qt5base qt5svg
XGXPERF_LICENSE = BSD-3-Clause
XGXPERF_INSTALL_STAGING = YES

XGXPERF_LIBS = \
	2dprimitives \
	automation \
	autoscreen \
	ecgmonitor \
	glwidget \
	vslib \
	widget \
	xgxperftemplate

XGXPERF_BINS = xgxperf_app xgxperf_launcher xgxperfserver

define XGXPERF_CONFIGURE_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/qmake xgxperf/xgxperf.pro)
endef

define XGXPERF_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define XGXPERF_CLEAN_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean
endef

define XGXPERF_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

define XGXPERF_UNINSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) uninstall
endef

define XGXPERF_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/qt/xgxperf
	find $(@D) -name 'lib*.so*' \
		-exec cp -dpf {} $(TARGET_DIR)/usr/lib/qt/xgxperf \;
	$(INSTALL) -m 755 $(@D)/applicationmanager/xgxperf_app/xgxperf_app \
		$(TARGET_DIR)/usr/bin/xgxperf_app
	$(INSTALL) -m 755 $(@D)/applicationmanager/xgxperf_launcher/xgxperf_launcher \
		$(TARGET_DIR)/usr/bin/xgxperf_launcher
	$(INSTALL) -m 755 $(@D)/xgxperfserver/xgxperfserver \
		$(TARGET_DIR)/usr/bin/xgxperfserver
endef

define XGXPERF_UNINSTALL_TARGET_CMDS
	for lib in $(XGXPERF_LIBS); do \
		$(RM) -f $(TARGET_DIR)/usr/lib/qt/xgxperf/lib$${lib}.so*; \
	done
	for prog in $(XGXPERF_BINS); do \
		$(RM) -f $(TARGET_DIR)/usr/bin/$${prog}; \
	done
endef

define XGXPERF_ADD_LIB_PATH
	echo "/usr/lib/qt/xgxperf/" >> $(TARGET_DIR)/etc/ld.so.conf
endef

XGXPERF_POST_INSTALL_TARGET_HOOKS += XGXPERF_ADD_LIB_PATH

$(eval $(generic-package))
