################################################################################
#
# diffutils
#
################################################################################

DIFFUTILS_VERSION = 3.6
DIFFUTILS_SOURCE = diffutils-$(DIFFUTILS_VERSION).tar.xz
DIFFUTILS_SITE = $(BR2_GNU_MIRROR)/diffutils
DIFFUTILS_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)
DIFFUTILS_LICENSE = GPL-3.0+
DIFFUTILS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_BUSYBOX),y)
DIFFUTILS_DEPENDENCIES += busybox
endif

$(eval $(autotools-package))
