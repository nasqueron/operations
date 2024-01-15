#!/bin/sh

set -e

TARGET=/usr/local/bin/python3

if [ -f $TARGET ]; then
    echo "The python3 command already exists." >&2
    exit 2
fi

CANDIDATE=$(pkg info | grep python3 | awk '{print $1}' | xargs -n1 pkg info -l | grep /usr/local/bin/python3 | grep -v config | awk '{print $1}' | head -n1)

if [ -z "$CANDIDATE" ]; then
    echo "Can't find Python 3 interpreter" >&2
    exit 1
fi

ln -s "$CANDIDATE" $TARGET
