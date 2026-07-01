#!/bin/sh
# shellcheck disable=SC2086

#   -------------------------------------------------------------
#   rOPS — determine IPv6 router with neighbor discovery protocol
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Read the output of `ndp -an` to find the first
#                   IP address not matching one of the server MAC.
#                   That should be a de facto gateway.
#   -------------------------------------------------------------

set -e

#   -------------------------------------------------------------
#   Parse arguments
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -z "$1" ]; then
    echo "Usage: $0 <interface>"
    echo "Example: $0 igb0"
    exit 1
fi

IFACE="$1"

#   -------------------------------------------------------------
#   Collect local MAC addresses
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LOCAL_MACS=$(ifconfig "$IFACE" | while read -r line; do
    case "$line" in
        *ether*) set -- $line; echo "$2";;
    esac
done)

LOCAL_MACS_STR=""
for m in $LOCAL_MACS; do
    LOCAL_MACS_STR="$LOCAL_MACS_STR $m"
done

#   -------------------------------------------------------------
#   Parse ndp -an output
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

skip=1
ndp -an | while read -r ipv mac rest; do
    # Skip header or incomplete entry
    if [ $skip -eq 1 ]; then skip=0; continue; fi
    [ "$mac" = "(incomplete)" ] && continue

    # Skip local MACs
    found=0
    for m in $LOCAL_MACS_STR; do
        [ "$mac" = "$m" ] && found=1 && break
    done
    [ $found -eq 1 ] && continue

    # We've got a winner!
    case "$ipv" in
        *%*) ipv=${ipv%%%*} ;;
    esac

    echo "$ipv"
    break
done
