################################################################################
#
# archivemount
#
################################################################################

ARCHIVEMOUNT_VERSION = 0.8.3
ARCHIVEMOUNT_SITE = http://www.cybernoia.de/software/archivemount/
ARCHIVEMOUNT_LICENSE = LGPLv2
ARCHIVEMOUNT_LICENSE_FILES = COPYING

ARCHIVEMOUNT_DEPENDENCIES = host-pkgconf libarchive libfuse

$(eval $(autotools-package))
