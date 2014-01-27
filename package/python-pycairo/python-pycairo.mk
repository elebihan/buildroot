################################################################################
#
# python-pycairo
#
################################################################################

PYTHON_PYCAIRO_VERSION = 1.10.0
PYTHON_PYCAIRO_SITE = http://cairographics.org/releases/
PYTHON_PYCAIRO_SOURCE = py2cairo-$(PYTHON_PYCAIRO_VERSION).tar.bz2
PYTHON_PYCAIRO_LICENSE = Dual LGPLv2.1+/MPLv1.1
PYTHON_PYCAIRO_LICENSE_FILES = COPYING-LGPL-2.1 COPYING-MPL-1.1

PYTHON_PYCAIRO_DEPENDENCIES = host-pkgconf cairo python-xpyb

PYTHON_PYCAIRO_INSTALL_STAGING = YES

PYTHON_PYCAIRO_AUTORECONF = YES

PYTHON_PYCAIRO_CONF_ENV = PYTHON_INCLUDES="-I${TARGET_DIR}/usr/include/python$(PYTHON_VERSION_MAJOR)"

$(eval $(autotools-package))
