#!/bin/sh

#   -------------------------------------------------------------
#   Sets permissions for a group-shared Git repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#                   If eligible, BSD-2-Clause
#   Source file:    roles/salt-primary/software/files/autochmod-git.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

set -e

#   -------------------------------------------------------------
#   Ensure user is root
#
#   Note: POSIX shells don't always define $UID or $EUID.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ "$(id -u)" -ne 0 ]; then
    echo "This command must be run as root." >&2
    exit 1
fi

#   -------------------------------------------------------------
#   Git information
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dir=$(git rev-parse --show-toplevel)

#   -------------------------------------------------------------
#   Let's chmod
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set -x

find "$dir" -print0 -type d | xargs -0 chmod g+xw
find "$dir" -print0 -type f | xargs -0 chmod g+w
