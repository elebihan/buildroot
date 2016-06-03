################################################################################
#
# clutter
#
################################################################################

CLUTTER_VERSION_MAJOR = 1.26
CLUTTER_VERSION_MINOR = 0
CLUTTER_VERSION = $(CLUTTER_VERSION_MAJOR).$(CLUTTER_VERSION_MINOR)
CLUTTER_SOURCE = clutter-$(CLUTTER_VERSION).tar.xz
CLUTTER_SITE = http://ftp.gnome.org/pub/gnome/sources/clutter/$(CLUTTER_VERSION_MAJOR)
CLUTTER_LICENSE = LGPLv2.1+
CLUTTER_LICENSE_FILES = COPYING
CLUTTER_INSTALL_STAGING = YES

CLUTTER_DEPENDENCIES = host-pkgconf libglib2 atk cairo cogl json-glib pango

CLUTTER_DEMO_BINARIES = \
	basic-actor \
	box-layout \
	canvas \
	constraints \
	drag-action \
	drop-action \
	flow-layout \
	grid-layout \
	layout-manager \
	pan-action \
	rounded-rectangle \
	scroll-actor \
	threads


CLUTTER_CONF_OPTS = \
	--disable-nls \
	--disable-introspection \
	--disable-gdk-backend \
	--disable-cex100-backend \
	--disable-wayland-compositor \
	--disable-tests \
	--disable-gtk-doc \
	--disable-gtk-doc-html

ifeq ($(BR2_PACKAGE_CLUTTER_BACKEND_EGL),y)
CLUTTER_CONF_OPTS += --enable-egl-backend
CLUTTER_DEPENDENCIES += libegl
else
CLUTTER_CONF_OPTS += --disable-egl-backend
endif

ifeq ($(BR2_PACKAGE_CLUTTER_BACKEND_WAYLAND),y)
CLUTTER_CONF_OPTS += --enable-wayland-backend
CLUTTER_DEPENDENCIES += wayland gdk-pixbuf
else
CLUTTER_CONF_OPTS += --disable-wayland-backend
endif

ifeq ($(BR2_PACKAGE_CLUTTER_BACKEND_X11),y)
CLUTTER_CONF_OPTS += --enable-x11-backend
CLUTTER_DEPENDENCIES += \
	xlib_libX11 \
	xlib_libXext \
	xlib_libXcomposite \
	xlib_libXfixes \
	xlib_libXdamage
else
CLUTTER_CONF_OPTS += --disable-x11-backend
endif

ifeq ($(BR2_PACKAGE_CLUTTER_INPUT_EVDEV),y)
CLUTTER_CONF_OPTS += --enable-evdev-input
CLUTTER_DEPENDENCIES += \
	udev \
	libxkbcommon \
	libevdev \
	libinput
else
CLUTTER_CONF_OPTS += --disable-evdev-input
endif

ifeq ($(BR2_PACKAGE_CLUTTER_INPUT_XINPUT),y)
CLUTTER_CONF_OPTS += --enable-xinput
CLUTTER_DEPENDENCIES += xlib_libXi
else
CLUTTER_CONF_OPTS += --disable-xinput
endif

ifeq ($(BR2_PACKAGE_CLUTTER_INSTALL_DEMOS),y)
CLUTTER_CONF_OPTS += --enable-examples --enable-gdk-pixbuf
CLUTTER_DEPENDENCIES += gdk-pixbuf
CLUTTER_POST_INSTALL_TARGET_HOOKS += CLUTTER_INSTALL_DEMOS_HOOK
else
CLUTTER_CONF_OPTS += --disable-examples --disable-gdk-pixbuf
endif

define CLUTTER_INSTALL_DEMOS_HOOK
	$(foreach demo,$(CLUTTER_DEMO_BINARIES),
		$(INSTALL) -D -m 0755 \
		$(@D)/examples/$(demo) \
		$(TARGET_DIR)/usr/share/clutter/examples/$(demo))
endef

$(eval $(autotools-package))
