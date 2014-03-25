################################################################################
#
# smack
#
################################################################################

SMACK_VERSION = 1.0.4
SMACK_SITE = $(call github,smack-team,smack,v$(SMACK_VERSION))
SMACK_LICENSE = LGPLv2.1+
SMACK_LICENSE_FILES = COPYING
SMACK_INSTALL_STAGING = YES
SMACK_AUTORECONF = YES

$(eval $(autotools-package))
