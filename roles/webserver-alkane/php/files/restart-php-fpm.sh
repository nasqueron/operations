#!/bin/sh

#   -------------------------------------------------------------
#   Restart php-fpm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/webserver-alkane/php/files/restart-php-fpm.sh
#   Description:    Deploy and restart php-fpm service
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
#   Update through Salt the service if needed & restart php-fpm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rm -f /usr/local/etc/rc.d/php_fpm
grep -q auto-generated /usr/local/etc/rc.d/php-fpm || salt-call state.apply roles/webserver-alkane/php/service
/usr/local/etc/rc.d/php-fpm restart
