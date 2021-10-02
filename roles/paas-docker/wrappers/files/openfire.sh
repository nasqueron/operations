#!/bin/sh

#   -------------------------------------------------------------
#   PaaS Docker
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2019-01-01
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/paas-docker/wrappers/files/openfire.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

#   -------------------------------------------------------------
#   Helper methods
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

getcommandname() {
    basename "$0"
}

usage() {
    echo "Usage: $(getcommandname) <command>"
    exit 1
}

unknown_command() {
    echo "$(getcommandname): $COMMAND: unknown command"
    usage
}

#   -------------------------------------------------------------
#   Commands
#
#   :: propagate-certificate: copy a certificate into a Java keystore file
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

propagate_certificate() {
    DOMAIN=$1
    SOURCE=/srv/letsencrypt/etc/live/$DOMAIN
    TARGET=/srv/$INSTANCE/conf/security/tmp

    # Per Openfire src/java/org/jivesoftware/multiplexer/net/SSLConfig.java
    # This is used as a blank password.
    PASS=changeit

    if [ -z "$DOMAIN" ]; then
        echo "Please append the FQDN of the certificate to propagate (CN, not alt name)" >&2
        exit 2
    fi

    mkdir -p "$TARGET"
    openssl pkcs12 -export -out "$TARGET/cert-to-import.p12" -in "$SOURCE/fullchain.pem" -inkey "$SOURCE/privkey.pem" -name "$DOMAIN" -password "pass:$PASS"
    docker exec "$INSTANCE" keytool -importkeystore -deststorepass "$PASS" -srcstorepass "$PASS" -destkeystore /var/lib/openfire/conf/security/keystore -srckeystore "/var/lib/$INSTANCE/conf/security/tmp/cert-to-import.p12" -srcstoretype PKCS12 -deststoretype pkcs12
    rm -R "$TARGET"
}

#   -------------------------------------------------------------
#   Check arguments
#
#   $1: instance name
#   $2: command
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ $# -lt 2 ]; then
    usage
fi

COMMAND=$1
INSTANCE=$2
shift 2

#   -------------------------------------------------------------
#   Run command
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ "$COMMAND" = "propagate-certificate" ]; then
    propagate_certificate "$1"
else
    unknown_command
fi
