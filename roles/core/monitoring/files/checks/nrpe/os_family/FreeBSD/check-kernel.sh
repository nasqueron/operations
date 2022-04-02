#!/bin/sh

set -e
set -u

PATH=/bin:/usr/bin:/sbin

which freebsd-version > /dev/null || exit 3

VERSION_INSTALLED=$(freebsd-version -k)
VERSION_RUNNING=$(freebsd-version -r)

if [ "$VERSION_INSTALLED" != "$VERSION_RUNNING" ]; then
    echo "Reboot is needed for kernel upgrade $VERSION_RUNNING to $VERSION_INSTALLED"
    exit 1
fi

exit 0
