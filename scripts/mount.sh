#!/bin/bash 
# Mounts raspbian image root partition inside cerbero build system

IMG='raspbian_lite.img'
MNT='cerbero/config/raspbian-sysroot'

# Attach loopback device
LOOP_DEV=`losetup -f --show image/${IMG}`
if [[ $? != 0 ]]; then
    echo "Error attaching loopback device"
    exit 1
else
    echo "Attached base loopback at: $LOOP_DEV"
fi

# Fetch and parse partition info
LOOP=`basename ${LOOP_DEV}`
SECTOR_SIZE=`cat /sys/block/${LOOP}/queue/hw_sector_size`
ROOT_START=`fdisk -l $LOOP_DEV | grep ${LOOP_DEV}p2 | awk '{print $2}'`
echo "Located root partition at sector $ROOT_START (sector size: ${SECTOR_SIZE}B)"

# Mount root partition
mkdir -p $MNT
mount image/${IMG} -o loop,offset=$(($ROOT_START*$SECTOR_SIZE)),rw $MNT
if [[ $? != 0 ]]; then
    echo "Error mounting root partition"
else
    echo "Mounted root partition to $MNT"
fi

# Close loopback device
losetup -d $LOOP_DEV
echo "Closed loopback $LOOP_DEV"
