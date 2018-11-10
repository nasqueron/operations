#!/bin/sh

while IFS=' ' read -r eggdrop; do
    # Skip blank lines and comment lines
    take_first_character="?"
    first_character=${eggdrop%"${eggdrop#${take_first_character}}"}
    if [ "$first_character" = "#" ]; then
        continue
    elif [ "$eggdrop" = "" ]; then
        continue
    fi

    service eggdrop status "$eggdrop" > /dev/null
    status=$?

    if [ $status -ne 0 ]; then
        service eggdrop restart "$eggdrop"
    fi
done < /usr/local/etc/eggdrops-live.conf
