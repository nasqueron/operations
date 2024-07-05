#!/bin/sh

#   -------------------------------------------------------------
#   Nasqueron PaaS :: Alkane :: Recipe for deployment
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/webserver-content/org/nasqueron/files/recipes/admin.mail.nasqueron.org/init.sh
#   Action:         init
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

set -e

git clone https://github.com/opensolutions/ViMbAdmin.git "$ALKANE_SITE_PATH"
cd "$ALKANE_SITE_PATH"
git remote add nasqueron https://github.com/dereckson/ViMbAdmin.git
git fetch --all
git checkout nasqueron/production -b production

composer install --prefer-dist --no-dev