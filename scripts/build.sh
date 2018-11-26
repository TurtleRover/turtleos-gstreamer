#!/bin/bash
# Builds Gstreamer package

# stop at first failed command
set -e

# Bootstrap cerbero environment
cerbero/cerbero-uninstalled -c cerbero/config/cross-lin-rpi.cbc bootstrap

# Build and package gstreamer for turtle
mkdir -p output/
cerbero/cerbero-uninstalled -c cerbero/config/cross-lin-rpi.cbc package -t gstreamer-1.0-turtle -o output/