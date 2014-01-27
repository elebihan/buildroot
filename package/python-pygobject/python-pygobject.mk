################################################################################
#
# python-pygobject
#
################################################################################

PYTHON_PYGOBJECT_VERSION_MAJOR = 2.28
PYTHON_PYGOBJECT_VERSION_MINOR = 6
PYTHON_PYGOBJECT_VERSION = $(PYTHON_PYGOBJECT_VERSION_MAJOR).$(PYTHON_PYGOBJECT_VERSION_MINOR)
PYTHON_PYGOBJECT_SITE = http://ftp.gnome.org/pub/GNOME/sources/pygobject/$(PYTHON_PYGOBJECT_VERSION_MAJOR)/
PYTHON_PYGOBJECT_SOURCE = pygobject-$(PYTHON_PYGOBJECT_VERSION).tar.bz2
PYTHON_PYGOBJECT_LICENSE = LGPLv2.1+
PYTHON_PYGOBJECT_LICENSE_FILES = COPYING

PYTHON_PYGOBJECT_DEPENDENCIES = host-pkgconf host-python python libglib2

PYTHON_PYGOBJECT_INSTALL_STAGING = YES

PYTHON_PYGOBJECT_AUTORECONF = YES

PYTHON_PYGOBJECT_CONF_OPT = --enable-introspection=no \
			  --enable-cairo=no \
			  --disable-ffi

PYTHON_PYGOBJECT_CONF_ENV = \
	PYTHON_INCLUDES="-I${TARGET_DIR}/usr/include/python$(PYTHON_VERSION_MAJOR)"
	

# Fixup path for codegen and defs
define PYTHON_PYGOBJECT_FIXUP_PC_FILE
	$(SED) 's|=$${datadir}/|=$(STAGING_DIR)/usr/share/|' \
		$(STAGING_DIR)/usr/lib/pkgconfig/pygobject-2.0.pc
endef

PYTHON_PYGOBJECT_POST_INSTALL_STAGING_HOOKS += PYTHON_PYGOBJECT_FIXUP_PC_FILE

$(eval $(autotools-package))
