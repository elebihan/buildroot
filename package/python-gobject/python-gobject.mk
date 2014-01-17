################################################################################
#
# python-gobject
#
################################################################################

PYTHON_GOBJECT_VERSION_MAJOR = 2.28
PYTHON_GOBJECT_VERSION_MINOR = 6
PYTHON_GOBJECT_VERSION = $(PYTHON_GOBJECT_VERSION_MAJOR).$(PYTHON_GOBJECT_VERSION_MINOR)
PYTHON_GOBJECT_SITE = http://ftp.gnome.org/pub/GNOME/sources/pygobject/$(PYTHON_GOBJECT_VERSION_MAJOR)/
PYTHON_GOBJECT_SOURCE = pygobject-$(PYTHON_GOBJECT_VERSION).tar.bz2
PYTHON_GOBJECT_DEPENDENCIES = host-pkgconf host-python libglib2

PYTHON_GOBJECT_CONF_OPT = --enable-introspection=no \
			  --enable-cairo=no \
			  --disable-ffi

$(eval $(autotools-package))
