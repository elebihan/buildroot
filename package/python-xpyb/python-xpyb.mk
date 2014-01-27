################################################################################
#
# python-xpyb
#
################################################################################

PYTHON_XPYB_VERSION = 1.3.1
PYTHON_XPYB_SITE = http://xcb.freedesktop.org/dist/
PYTHON_XPYB_SOURCE = xpyb-$(PYTHON_XPYB_VERSION).tar.bz2
PYTHON_XPYB_LICENSE = Public domain
PYTHON_XPYB_LICENSE_FILES = COPYING
PYTHON_XPYB_DEPENDENCIES = host-pkgconf host-python python xproto_xproto xcb-proto
PYTHON_XPYB_INSTALL_STAGING = YES
PYTHON_XPYB_AUTORECONF = YES

PYTHON_XPYB_CONF_ENV = PYTHON_INCLUDE="${TARGET_DIR}/usr/include/python$(PYTHON_VERSION_MAJOR)"

$(eval $(autotools-package))
