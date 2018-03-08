#!/bin/sh

ARC=arc
SHELLUSERS=pillar/users/shellusers.sls
PROJECT=Eglide
KEYS_TEMPLATE=P267

[ -z "$EDITOR" ] && EDITOR=nano

if [ $# -ne 1 ]
then
    >&2 echo "Usage: $(basename "$0") <username>"
    exit 64
fi
ACCOUNT=$1

if [ ! -f $SHELLUSERS ]
then
    >&2 echo "You must run this at the top of a rOPS working copy."
    exit 66
fi

LASTUID=$(grep 'uid: 2' $SHELLUSERS | sort | tail -n 1 | awk '{print $2}')
NEWUID=$((LASTUID + 1))
{
    echo "  $ACCOUNT:"
    echo "    fullname: $ACCOUNT"
    echo "    uid: $NEWUID"
} >> $SHELLUSERS

AUTHORIZED_KEYS=roles/shellserver/users/files/ssh_keys/$ACCOUNT
$EDITOR $SHELLUSERS
$ARC paste $KEYS_TEMPLATE | sed "s/%%username%%/$ACCOUNT/g; s/%%project%%/$PROJECT/g" > "$AUTHORIZED_KEYS"
$EDITOR "$AUTHORIZED_KEYS"
$ARC feature "account/$ACCOUNT"
git status
