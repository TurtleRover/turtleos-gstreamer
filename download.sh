#!/bin/bash
# Downloads latest raspbian lite image

ZIP=raspbian_lite.zip
IMG=raspbian_lite.img
URL=https://downloads.raspberrypi.org/raspbian_lite_latest

echo "Downloading latest raspbian lite release"
mkdir -p image
wget $URL -O image/${ZIP}

echo "Extracting image"
unzip image/${ZIP} -d image/

FILE=`zipinfo -1 image/${ZIP}`
mv image/${FILE} image/${IMG}