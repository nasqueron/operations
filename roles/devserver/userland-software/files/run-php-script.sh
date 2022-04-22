#!/bin/sh

#   -------------------------------------------------------------
#   Wrapper to launch PHP command from known places
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Source:         roles/devserver/userland-software/files/run-php-script.sh
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

COMMAND=$1
shift

if [ -f "vendor/bin/$COMMAND" ]; then
    echo "Switching to Composer $COMMAND:"
    SCRIPT="vendor/bin/$COMMAND"
elif [ -f "/opt/$COMMAND.phar" ]; then
    SCRIPT="/opt/$COMMAND.phar"
elif [ -f "/opt/$COMMAND" ]; then
    SCRIPT="/opt/$COMMAND"
else
    echo "No $COMMAND has been found."
    exit 1
fi

php "$SCRIPT" "$@"
