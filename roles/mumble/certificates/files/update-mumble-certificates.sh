#!/bin/sh

#   -------------------------------------------------------------
#   Deploy Mumble certificate on Murmur
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-11-03
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/mumble/certificates/files/update-mumble-certificates.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

: ${JAIL_HOSTNAME='mumble.nasqueron.org'}
: ${CERT_DIR="/usr/local/etc/letsencrypt/live/$JAIL_HOSTNAME"}
: ${JAIL_DIR="/usr/local/jails/$JAIL_HOSTNAME"}
: ${JAIL_ID=`jls | grep $JAIL_HOSTNAME | awk '{print $1}'`}

cp $CERT_DIR/fullchain.pem $JAIL_DIR/usr/local/etc/ssl/nasqueron.org/mumble.crt
cp $CERT_DIR/privkey.pem $JAIL_DIR/usr/local/etc/ssl/nasqueron.org/mumble.key

# murmur has uid 338
chown 338:0 $JAIL_DIR/usr/local/etc/ssl/nasqueron.org/mumble.key
chmod 400 $JAIL_DIR/usr/local/etc/ssl/nasqueron.org/mumble.key

jexec $JAIL_ID service murmur restart
