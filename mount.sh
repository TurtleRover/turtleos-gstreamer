#!/bin/bash 
# Mounts raspbian image inside cerbero build system

IMG='raspbian_lite.img'
MNT='cerbero/config/raspbian_sysroot'

# Attach loopback device
LOOP_DEV=`losetup -f --show image/${IMG}`
echo "Attached base loopback at: $LOOP_DEV"

# Fetch and parse partition info
LOOP=`basename ${LOOP_DEV}`
SECTOR_SIZE=`cat /sys/block/${LOOP}/queue/hw_sector_size`
ROOT_START=`fdisk -l $LOOP_DEV | grep ${LOOP_DEV}p2 | awk '{print $2}'`
echo "Located root partition at sector $ROOT_START (sector size: ${SECTOR_SIZE}B)"

mkdir -p $MNT
mount image/${IMG} -o loop,offset=$(($ROOT_START*$SECTOR_SIZE)),rw $MNT
if [[ $? != 0 ]]; then
    echo "Error mounting root partition"
else
    echo "Mounted root partition to $MNT"
fi

losetup -d $LOOP_DEV
echo "Closed loopback $LOOP_DEV"
