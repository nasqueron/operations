#!/bin/sh

ARC=arc
AWK=gawk
URL="https://devcentral.nasqueron.org"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <title of the task to create>"
    exit 64
fi
TEXT=$1

arcTaskCreatedId=$($ARC todo "$TEXT" --project servers --no-ansi --conduit-uri "$URL"/api | $AWK '{match($3,"T[0-9]+",a)}END{print a[0]}' | cut -d'T' -f 2)
echo $URL/T"$arcTaskCreatedId"
