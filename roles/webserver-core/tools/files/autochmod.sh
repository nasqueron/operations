#!/bin/sh

#   -------------------------------------------------------------
#   Default permissions for a secure webserver installation
#   Compliant with SuEXEC or php-fpm pools
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Created:        2017-01-24
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/webserver-legacy/files/autochmod.sh
#   Usage:          autochmod [for dirs] [for files] [for scripts]
#                   (by default use 711, 644 and 700)
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

DIR_CHMOD=${1:-711}
FILE_CHMOD=${2:-644}
SCRIPT_CHMOD=${3-700}

find . -type d -print0 | xargs -0 chmod "$DIR_CHMOD"

# By default, functions should be edited
find . -type f -print0 | xargs -0 chmod "$FILE_CHMOD"

# Avoid application code to be world-readable,
# to protect files with credentials exposure.
# They are marked executable to be allowed as CGI.
find . -type f -iname "*.php" -print0 | xargs -0 chmod "$SCRIPT_CHMOD"
find . -type f -iname "*.php3" -print0 | xargs -0 chmod "$SCRIPT_CHMOD"
find . -type f -iname "*.phps" -print0 | xargs -0 chmod "$SCRIPT_CHMOD"
find . -type f -iname "*.tcl" -print0 | xargs -0 chmod "$SCRIPT_CHMOD"
find . -type f -iname "*.cgi" -print0 | xargs -0 chmod "$SCRIPT_CHMOD"
find . -type f -iname "*.pl" -print0 | xargs -0 chmod "$SCRIPT_CHMOD"
find . -type f -iname "*.py" -print0 | xargs -0 chmod "$SCRIPT_CHMOD"