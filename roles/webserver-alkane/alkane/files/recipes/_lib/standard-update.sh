#!/bin/sh

#   -------------------------------------------------------------
#   Nasqueron PaaS :: Alkane :: Recipe for deployment
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/webserver-alkane/alkane/files/recipes/_lib/standard-update.sh
#   Action:         update
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

set -e

sh "$ALKANE_RECIPES_PATH/_lib/git-pull.sh"
sh "$ALKANE_RECIPES_PATH/_lib/update-packages.sh"
