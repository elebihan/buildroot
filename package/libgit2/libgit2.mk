################################################################################
#
# libgit2
#
################################################################################

LIBGIT2_VERSION = v0.24.0
LIBGIT2_SITE = $(call github,libgit2,libgit2,$(LIBGIT2_VERSION))
LIBGIT2_LICENSE = GPLv2 with exception
LIBGIT2_LICENSE_FILES = COPYING
LIBGIT2_INSTALL_STAGING = YES
LIBGIT2_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_LIBCURL),y)
LIBGIT2_DEPENDENCIES += libcurl
endif

ifeq ($(BR2_PACKAGE_LIBHTTPPARSER),y)
LIBGIT2_DEPENDENCIES += libhttpparser
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBGIT2_DEPENDENCIES += openssl
endif

ifeq ($(BR2_PACKAGE_LIBSSH2),y)
LIBGIT2_DEPENDENCIES += libssh2
endif

$(eval $(cmake-package))
$(eval $(host-cmake-package))
