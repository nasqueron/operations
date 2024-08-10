#!/bin/sh

set -e
set -u

if [ ! -f /var/run/os-release ]; then
    echo "Restart service os-release to generate missing os-release file."
    exit 2
fi

PATH=/bin:/usr/bin:/sbin
which freebsd-version > /dev/null || exit 3
VERSION_INSTALLED=$(freebsd-version -k)

. /var/run/os-release

if [ "$VERSION_INSTALLED" != "$VERSION" ]; then
    echo "/etc/os-release isn't up-to-date, restart os-release service"
    exit 1
fi

exit 0
