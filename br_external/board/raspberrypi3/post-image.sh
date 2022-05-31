#!/bin/bash

set -e

# copy over basic config templates
mkdir -p "${BINARIES_DIR}/config/etc"
cp "${TARGET_DIR}/etc/"{hostname,wpa_supplicant.conf,direwolf.conf} "${BINARIES_DIR}/config/etc/"
mkdir -p "${BINARIES_DIR}/config"{/home/pidgey/.ssh/,/var/lib/alsa/,/etc/wireguard/}
touch -a "${BINARIES_DIR}/config"{/home/pidgey/.ssh/authorized_keys,/var/lib/alsa/asound.state}

# initialize git repo for config
[ -e "${BINARIES_DIR}/config/.git" ] || git -C "${BINARIES_DIR}/config/" init
git -C "${BINARIES_DIR}/config/" config user.email "pidgey@w1fn-pidgey"
git -C "${BINARIES_DIR}/config/" config user.name "W1FN Pidgey"
git -C "${BINARIES_DIR}/config/" config core.fileMode false
git -C "${BINARIES_DIR}/config/" add -A && git -C "${BINARIES_DIR}/config/" commit -m "Initial Commit" || :

# run genimage
BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# Pass an empty rootpath. genimage makes a full copy of the given rootpath to
# ${GENIMAGE_TMP}/root so passing TARGET_DIR would be a waste of time and disk
# space. We don't rely on genimage to build the rootfs image, just to insert a
# pre-built one in the disk image.

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

rm -rf "${GENIMAGE_TMP}"

genimage \
	--rootpath "${ROOTPATH_TMP}"   \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
