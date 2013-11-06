#!/bin/sh

mkdir_if_missing() {
	test -d $1 || mkdir -p $1
}

RANDOM_SEED=${TARGET_DIR}/var/lib/random-seed
PASSWD_HASH='$1$nzCQVFOS$xUdFp8hRrWcGmIFKgnqxS0' # root

echo "Adding missing directories"
mkdir_if_missing ${TARGET_DIR}/etc/dropbear

echo "Initializing ${RANDOM_SEED}"
touch ${RANDOM_SEED}
chmod 600 ${RANDOM_SEED}
dd if=/dev/urandom of=${RANDOM_SEED} count=1 bs=512 2>/dev/null

echo "Setting password for super-user"
sed -i -e "s;^root:.*;root:${PASSWD_HASH}:0:0:99999:7:::;g" ${TARGET_DIR}/etc/shadow
