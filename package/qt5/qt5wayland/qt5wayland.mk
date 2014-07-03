################################################################################
#
# qt5wayland
#
################################################################################

QT5WAYLAND_VERSION = d3d3f8f45b134eabf340f761f75cd1b5ba104bc8
QT5WAYLAND_SITE = git://gitorious.org/qt/qtwayland.git
QT5WAYLAND_INSTALL_STAGING = YES
QT5WAYLAND_DEPENDENCIES = qt5base qt5declarative libxkbcommon wayland

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5WAYLAND_LICENSE = LGPLv2.1 or GPLv3.0
QT5WAYLAND_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL LGPL_EXCEPTION.txt
else
QT5WAYLAND_LICENSE = Commercial license
QT5WAYLAND_REDISTRIBUTE = NO
endif

QT5WAYLAND_QMAKE_OPT = CONFIG+=c++11

define QT5WAYLAND_COMPOSITOR_SYNC_CMD
	(cd $(@D)/src/compositor; \
		$(HOST_DIR)/usr/bin/syncqt.pl \
		-check-includes \
		-module QtCompositor \
		-version $(QT5_VERSION) \
		-outdir $(@D) $(@D))
endef

define QT5WAYLAND_CLIENT_SYNC_CMD
	(cd $(@D)/src/client; \
		$(HOST_DIR)/usr/bin/syncqt.pl \
		-check-includes \
		-module QtWaylandClient \
		-version $(QT5_VERSION) \
		-outdir $(@D) $(@D))
endef

ifeq ($(BR2_PACKAGE_QT5WAYLAND_COMPOSITOR_API),y)
QT5WAYLAND_QMAKE_OPT += CONFIG+=wayland-compositor
define QT5WAYLAND_INSTALL_COMPOSITOR
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/qt/plugins/wayland-graphics-integration/client
	cp -dpf $(@D)/plugins/wayland-graphics-integration/client/*.so \
		$(TARGET_DIR)/usr/lib/qt/plugins/wayland-graphics-integration/client/
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/qt/plugins/wayland-graphics-integration/server
	cp -dpf $(@D)/plugins/wayland-graphics-integration/server/*.so \
		$(TARGET_DIR)/usr/lib/qt/plugins/wayland-graphics-integration/server/
	cp -dpf $(@D)/lib/libQt5*.so* $(TARGET_DIR)/usr/lib/
endif
define QT5WAYLAND_UNINSTALL_COMPOSITOR
	$(RM) -f $(TARGET_DIR)/usr/lib/libQt5Compositor.so
endef
endif

define QT5WAYLAND_CONFIGURE_CMDS
	$(QT5WAYLAND_CLIENT_SYNC_CMD)
	$(QT5WAYLAND_COMPOSITOR_SYNC_CMD)
	(cd $(@D); \
		$(SED) 's/^MODULE_VERSION = .*/MODULE_VERSION = $(QT5_VERSION)/' \
		.qmake.conf)
	(cd $(@D); \
		$(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake \
		$(QT5WAYLAND_QMAKE_OPT))
endef

define QT5WAYLAND_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5WAYLAND_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

define QT5WAYLAND_UNINSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) uninstall
endef

define QT5WAYLAND_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/qt/plugins/platforms
	cp -dpf $(@D)/plugins/platforms/*.so $(TARGET_DIR)/usr/lib/qt/plugins/platforms
	$(QT5WAYLAND_INSTALL_COMPOSITOR)
endef

define QT5WAYLAND_UNINSTALL_STAGING_CMDS
	$(RM) -rf $(TARGET_DIR)/usr/lib/qt/plugins/platforms
	$(RM) -f $(TARGET_DIR)/usr/lib/libQt5WaylandClient.so
	$(QT5WAYLAND_UNINSTALL_COMPOSITOR)
endef

$(eval $(generic-package))
