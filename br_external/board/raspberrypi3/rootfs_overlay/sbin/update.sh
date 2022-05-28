#!/bin/sh

set -e

source="${1:-http://${SSH_CLIENT%% *}:8000/update.rauc}"

wget "$source" -O /tmp/update.rauc

modprobe dm_verity

if [ -z "$(awk '$2~/\/boot/' /proc/mounts)" ]
then
    echo "mounting /boot rw"
    mount -o rw /boot
    cleanup () {
        echo "unmounting /boot"
        umount /boot
    }
elif [ -z "$(awk '$2~/\/boot/ && $4~/(^|,)rw($|,)/' /proc/mounts)" ]
then
    echo "remounting /boot rw"
    mount -o remount,rw /boot
    cleanup () {
        echo "remounting /boot ro"
        mount -o remount,ro /boot
    }
fi

rauc install /tmp/update.rauc
