#!/bin/sh

set -u
set -e


function add_line () {
    file=${TARGET_DIR}/"$1"
    position="$2"
    line="$3"
    if ! grep -qFx "$line" "$file"
    then
        sed -i "$file" -e "${position} $line"
    fi
}

if [ -e ${TARGET_DIR}/etc/fstab ]; then
    # Add entry for /boot
    add_line /etc/fstab '$a' '/dev/mmcblk0p1	/boot		vfat	defaults,ro,noatime	0	2'

    # Mount first block device on /mnt, if it exists
    add_line /etc/fstab '$a' '/dev/sda1	/mnt		vfat	defaults,noatime,nofail	0	2'
fi

if [ -e ${TARGET_DIR}/etc/inittab ]; then
    # Add a console on tty1
    add_line /etc/inittab '/GENERIC_SERIAL/a' 'tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console'

    # # wait for devices to exist before mounting
    add_line /etc/inittab '/mount -a$/i' '::sysinit:/etc/init.d/waitmount /dev/mmcblk0p1 /dev/sda1 # wait for block devices'

    # Load wifi module
    add_line /etc/inittab '/any rc scripts$/i' '::sysinit:/sbin/modprobe brcmfmac'

    # use hostname from /boot/config
    sed -i ${TARGET_DIR}/etc/inittab -e 's|/etc/hostname|/boot/config/hostname|'

    # unmount /boot after init
    add_line /etc/inittab '\|/etc/init.d/rcS$|a' '::once:/bin/umount /boot'
fi

# replace dropbear config dir with real directory
if [ -L ${TARGET_DIR}/etc/dropbear ]; then
    rm ${TARGET_DIR}/etc/dropbear
    mkdir ${TARGET_DIR}/etc/dropbear
fi

# install RAUC certificate
install -D -m 0644 $BR2_EXTERNAL_PIDGEY_PATH/rauc-update.cert.pem ${TARGET_DIR}/etc/rauc/keyring.pem

cp $BR2_EXTERNAL_PIDGEY_PATH/rauc-update.{key,cert}.pem ${BINARIES_DIR}/

# Remove unused firmware files
UNNEEDED_FILES="brcmfmac43143.bin \
    brcmfmac43143-sdio.bin \
    brcmfmac43236b.bin \
    brcmfmac43241b0-sdio.bin \
    brcmfmac43241b4-sdio.bin \
    brcmfmac43241b5-sdio.bin \
    brcmfmac43242a.bin \
    brcmfmac43340-sdio.bin \
    brcmfmac43362-sdio.bin \
    brcmfmac43430a0-sdio.bin \
    brcmfmac43569.bin \
    brcmfmac43570-pcie.bin \
    brcmfmac43602-pcie.ap.bin \
    brcmfmac43602-pcie.bin"

if [ -d ${TARGET_DIR}/lib/firmware/brcm ]; then
    cd ${TARGET_DIR}/lib/firmware/brcm/
    for f in $UNNEEDED_FILES; do
        if [ -f $f ]; then
            rm $f
        fi
    done
fi
