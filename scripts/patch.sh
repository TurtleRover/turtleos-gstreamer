#!/bin/bash
# Patch cerbero build system

export GIT_DIR=$(pwd)/cerbero/.git
export GIT_WORK_TREE=$(pwd)/cerbero

# cherry-pick specified commits
cat patches/cherry-pick | while read COMMIT; do
    if git log --pretty=format:"%H" | grep -q $COMMIT; then
        echo "commit $COMMIT already on the working tree, skipping"
    else
        git cherry-pick $COMMIT
        if [[ $? != 0 ]]; then
            echo "Cherry-pick failed, aborting..."
            git cherry-pick --abort
        fi
    fi
done

# apply patches
if compgen -G patches/*.patch > /dev/null; then
    for patch in patches/*.patch
    do
        git am < "$patch"
        if [[ $? != 0 ]]; then
            echo "Patch failed, aborting..."
            git am --abort
        fi
    done
fi

# Copy cerbero configuration file and package description
cp cross-lin-rpi.cbc cerbero/config/
cp gstreamer-1.0-turtle.package cerbero/packages/