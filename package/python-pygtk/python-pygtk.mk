################################################################################
#
# python-pygtk
#
################################################################################

PYTHON_PYGTK_VERSION_MAJOR = 2.24
PYTHON_PYGTK_VERSION_MINOR = 0
PYTHON_PYGTK_VERSION = $(PYTHON_PYGTK_VERSION_MAJOR).$(PYTHON_PYGTK_VERSION_MINOR)
PYTHON_PYGTK_SITE = http://ftp.gnome.org/pub/GNOME/sources/pygtk/$(PYTHON_PYGTK_VERSION_MAJOR)/
PYTHON_PYGTK_SOURCE = pygtk-$(PYTHON_PYGTK_VERSION).tar.bz2
PYTHON_PYGTK_LICENSE = LGPLv2.1+
PYTHON_PYGTK_LICENSE_FILES = COPYING

PYTHON_PYGTK_DEPENDENCIES = \
	host-pkgconf \
	host-python \
	python \
	libgtk2	\
	libglade \
	python-pygobject \
	python-pycairo

PYTHON_PYGTK_INSTALL_STAGING = YES

PYTHON_PYGTK_AUTORECONF = YES

PYTHON_PYGTK_CONF_OPT = --disable-glibtest \
			--disable-numpy

PYTHON_PYGTK_CONF_ENV = \
	PYTHON_INCLUDES="-I${TARGET_DIR}/usr/include/python$(PYTHON_VERSION_MAJOR)"

$(eval $(autotools-package))
