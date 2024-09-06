#!/bin/sh

#   -------------------------------------------------------------
#   Remove a Let's Encrypt
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

set -e

#   -------------------------------------------------------------
#   Ensure user is root
#
#   Note: POSIX shells don't always define $UID or $EUID.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "This command must be run as root." >&2
    exit 1
fi

#   -------------------------------------------------------------
#   Parse arguments
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ $# -eq 0 ]; then
    echo "Usage: $(basename "$0") <certificate>" >&2
    exit 1
fi

CERTIFICATE=$1

#   -------------------------------------------------------------
#   Determine etc directory path
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

. /etc/os-release

if [ "$ID" = "freebsd" ]; then
    ETC=/usr/local/etc
else
    ETC=/etc
fi

#   -------------------------------------------------------------
#   Determine if the certificate exists
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ ! -f "$ETC/letsencrypt/live/$CERTIFICATE/chain.pem" ]; then
    echo "The certificate cannot be found." >&2
    exit 2
fi

#   -------------------------------------------------------------
#   Delete certificate and renewal information
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rm -rf "$ETC/letsencrypt/live/$CERTIFICATE"
rm -rf "$ETC/letsencrypt/archive/$CERTIFICATE"
rm "$ETC/letsencrypt/renewal/$CERTIFICATE.conf"
