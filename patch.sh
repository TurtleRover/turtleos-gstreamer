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
    fi
done

# Copy cerbero configuration file and package description
cp cross-lin-rpi.cbc cerbero/config/