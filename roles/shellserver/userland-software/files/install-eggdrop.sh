#!/bin/sh

#   -------------------------------------------------------------
#   Install an eggdrop
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-11-06
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/shellserver/userland-software/files/install-eggdrop.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

#   -------------------------------------------------------------
#   TCL and eggdrop versions
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

EGGDROP_VERSION_MAJOR=1.9
EGGDROP_VERSION=1.9.2rc2
TCL_VERSION=8.6

#   -------------------------------------------------------------
#   Fetch, extract
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

wget https://ftp.eggheads.org/pub/eggdrop/source/${EGGDROP_VERSION_MAJOR}/eggdrop-${EGGDROP_VERSION}.tar.gz
tar xzf eggdrop-${EGGDROP_VERSION}.tar.gz
cd eggdrop-${EGGDROP_VERSION} || exit 1

#   -------------------------------------------------------------
#   Configure step
#
#   This is the tricky part, as we need to provide path to TCL
#   header and library files, heavily OS/distro/arch dependant.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -f /etc/debian_version ]; then
	ARCH=$(dpkg-architecture -qDEB_HOST_MULTIARCH)
	CFLAGS="-std=gnu99" ./configure --with-tclinc=/usr/include/tcl${TCL_VERSION}/tcl.h --with-tcllib="/usr/lib/$ARCH/libtcl${TCL_VERSION}.so"
elif [ "$(uname)" = "FreeBSD" ]; then
	TCL_VERSION_LIB=$(echo $TCL_VERSION | tr -d .)
	./configure --with-tclinc=/usr/local/include/tcl${TCL_VERSION}/tcl.h -with-tcllib="/usr/local/lib/libtcl${TCL_VERSION_LIB}.so"
else
	./configure
fi

#   -------------------------------------------------------------
#   Build, install
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

make config
make
make install
