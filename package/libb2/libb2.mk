################################################################################
#
# libb2
#
################################################################################

LIBB2_VERSION = 9b8de7329ab3bd896523fca725d11ea619451f76
LIBB2_SITE = $(call github,BLAKE2,libb2,$(LIBB2_VERSION))
LIBB2_LICENSE = CC0
LIBB2_LICENSE_FILES = LICENSE
LIBB2_AUTORECONF = YES
LIBB2_INSTALL_STAGING = YES

$(eval $(autotools-package))
