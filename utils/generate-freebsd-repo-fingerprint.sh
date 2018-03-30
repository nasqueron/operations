#!/bin/sh

#   -------------------------------------------------------------
#   rOPS — regenerate FreeBSD Nasqueron repository fingerprint
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-30
#   Description:    Read the FreeBSD Nasqueron repository public key
#                   and regenerate the fingerprint.
#   -------------------------------------------------------------

KEY=/usr/local/etc/freebsd-pkg-repo/key/repo.pub
KEYS_DIR=roles/devserver/pkg/files/keys/trusted
FINGERPRINT=$KEYS_DIR/packages.nasqueron.org.$(date '+%Y%m%d01')

usage() {
    echo "You should run this script on the package builder server."
    echo "If you need to first regenerate the repository keys,"
    echo "invoke Salt with state.apply roles/freebsd-repo"
    exit 1
}

[ -f $KEY ] || usage
command -v sha256 >/dev/null 2>&1 || usage

mkdir -p $KEYS_DIR
echo "function: sha256" > "$FINGERPRINT"
echo "fingerprint: $(sha256 -q $KEY)" >> "$FINGERPRINT"
