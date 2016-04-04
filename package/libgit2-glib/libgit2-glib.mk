################################################################################
#
# libgit2-glib
#
################################################################################

LIBGIT2_GLIB_VERSION_MAJOR = 0.24
LIBGIT2_GLIB_VERSION = $(LIBGIT2_GLIB_VERSION_MAJOR).0
LIBGIT2_GLIB_SOURCE = libgit2-glib-$(LIBGIT2_GLIB_VERSION).tar.xz
LIBGIT2_GLIB_SITE = http://ftp.gnome.org/pub/gnome/sources/libgit2-glib/$(LIBGIT2_GLIB_VERSION_MAJOR)
LIBGIT2_GLIB_LICENSE = LGPLv2+
LIBGIT2_GLIB_LICENSE_FILES = COPYING
LIBGIT2_GLIB_AUTORECONF = YES
LIBGIT2_GLIB_INSTALL_STAGING = YES
LIBGIT2_GLIB_DEPENDENCIES = host-pkgconf libglib2 libgit2

LIBGIT2_GLIB_CONF_OPTS = --enable-introspection=no
LIBGIT2_GLIB_CONF_ENV =

ifeq ($(BR2_PACKAGE_LIBSSH2),y)
LIBGIT2_GLIB_CONF_ENV += ac_cv_git_ssh=yes
endif

$(eval $(autotools-package))
$(eval $(host-autools-package))
