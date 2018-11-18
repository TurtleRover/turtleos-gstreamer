#!/bin/bash

# Runs a build script and spawns background timer process that outputs elapsed time every minute
# This is used so that travis won't cancel build due to long period without output

cd "$(dirname "$0")"
./build.sh | ./timer.sh