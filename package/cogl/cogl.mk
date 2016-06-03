################################################################################
#
# cogl
#
################################################################################

COGL_VERSION_MAJOR = 1.22
COGL_VERSION_MINOR = 0
COGL_VERSION = $(COGL_VERSION_MAJOR).$(COGL_VERSION_MINOR)
COGL_SOURCE = cogl-$(COGL_VERSION).tar.xz
COGL_SITE = http://ftp.gnome.org/pub/gnome/sources/cogl/$(COGL_VERSION_MAJOR)
COGL_LICENSE = LGPLv2.1+
COGL_LICENSE_FILES = COPYING
COGL_INSTALL_STAGING = YES

COGL_DEPENDENCIES = host-pkgconf libglib2

COGL_CONF_OPTS = \
	--enable-unit-tests \
	--disable-maintainer-flags \
	--disable-nls \
	--disable-glibtest \
	--disable-introspection \
	--disable-android-egl-platform \
	--disable-gdl-egl-platform \
	--disable-kms-egl-platform \
	--disable-gles1

COGL_X11_DEPENDENCIES = \
	xlib_libX11 \
	xlib_libXext \
	xlib_libXdamage \
	xlib_libXfixes \
	xlib_libXrandr \
	xlib_libXcomposite \
	libxcb

ifeq ($(BR2_PACKAGE_COGL_OPENGL_GL),y)
COGL_CONF_OPTS += --enable-gl
COGL_DEPENDENCIES += libgl
else
COGL_CONF_OPTS += --disable-gl
endif

ifeq ($(BR2_PACKAGE_COGL_OPENGL_ES),y)
COGL_CONF_OPTS += \
	--enable-gles2
COGL_DEPENDENCIES += libgles
else
COGL_CONF_OPTS += \
	--disable-gles2
endif

ifeq ($(BR2_PACKAGE_COGL_GLX),y)
COGL_CONF_OPTS += --enable-glx
else
COGL_CONF_OPTS += --disable-glx
endif

ifeq ($(BR2_PACKAGE_COGL_SDL),y)
COGL_CONF_OPTS += --enable-sdl
else
COGL_CONF_OPTS += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_COGL_SDL2),y)
COGL_CONF_OPTS += --enable-sdl2
else
COGL_CONF_OPTS += --disable-sdl2
endif

ifeq ($(BR2_PACKAGE_COGL_EGL_WAYLAND),y)
COGL_CONF_OPTS += --enable-wayland-egl-platform --enable-wayland-egl-server
COGL_DEPENDENCIES += libwayland-egl
else
COGL_CONF_OPTS += --disable-wayland-egl-platform --disable-wayland-egl-server
endif

ifeq ($(BR2_PACKAGE_COGL_EGL_XLIB),y)
COGL_CONF_OPTS += --enable-xlib-egl-platform
COGL_DEPENDENCIES += libegl $(COGL_X11_DEPENDENCIES)
else
COGL_CONF_OPTS += --disable-xlib-egl-platform
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
COGL_CONF_OPTS += --enable-null-egl-platform
COGL_DEPENDENCIES += libegl
else
COGL_CONF_OPTS += --disable-null-egl-platform
endif

ifeq ($(BR2_PACKAGE_CAIRO),y)
COGL_CONF_OPTS += --enable-cairo=yes
COGL_DEPENDENCIES += cairo
else
COGL_CONF_OPTS += --enable-cairo=no
endif

ifeq ($(BR2_PACKAGE_PANGO),y)
COGL_CONF_OPTS += --enable-cogl-pango
COGL_DEPENDENCIES += pango
else
COGL_CONF_OPTS += --disable-cogl-pango
endif

ifeq ($(BR2_PACKAGE_GDK_PIXBUF),y)
COGL_CONF_OPTS += --enable-gdk-pixbuf
COGL_DEPENDENCIES += gdk-pixbuf
else
COGL_CONF_OPTS += --disable-gdk-pixbuf
endif

ifeq ($(BR2_PACKAGE_GSTREAMER1),y)
COGL_CONF_OPTS += --enable-cogl-gst
COGL_DEPENDENCIES += gstreamer1
else
COGL_CONF_OPTS += --disable-cogl-gst
endif

ifeq ($(BR2_PACKAGE_COGL_INSTALL_DEMOS),y)
COGL_CONF_OPTS += --enable-examples-install
else
COGL_CONF_OPTS += --disable-examples-install
endif

$(eval $(autotools-package))
