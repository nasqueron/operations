#!/bin/sh

#   -------------------------------------------------------------
#   ZFS :: Build for Ubuntu 20.04 (Focal Fossa)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Build recent ZFS for Scaleway / Dedibox rescue console
#   -------------------------------------------------------------

set -e

#   -------------------------------------------------------------
#   Ensure user is root
#
#   Note: POSIX shells don't always define $UID or $EUID.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# shellcheck disable=SC3028
if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "This command must be run as root." >&2
    exit 1
fi

#   -------------------------------------------------------------
#   Dependencies
#
#   Tested with:    Ubuntu 20.04.6 LTS (Focal Fossa)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

apt install "linux-headers-$(uname -r)"

apt install alien autoconf automake build-essential \
    debhelper-compat dh-autoreconf dh-python \
    dkms fakeroot gawk git libaio-dev libattr1-dev libblkid-dev \
    libcurl4-openssl-dev libelf-dev libffi-dev libpam0g-dev libssl-dev \
    libtirpc-dev libtool libudev-dev \
    parallel po-debconf python3 python3-all-dev python3-cffi \
    python3-dev python3-packaging python3-setuptools python3-sphinx \
    uuid-dev zlib1g-dev

# Package missing compared to build instructions:
#   - dh-dkms, but dh_dkms is provided by dkms package

#   -------------------------------------------------------------
#   Build
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

git clone https://github.com/openzfs/zfs
cd zfs

sh autogen.sh
./configure
make -s -j "$(nproc)"

#   -------------------------------------------------------------
#   Install
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

BASE_SOURCES=$(cat /etc/depmod.d/ubuntu.conf)
echo "$BASE_SOURCES" extra > /etc/depmod.d/ubuntu.conf

make install
ldconfig
depmod
