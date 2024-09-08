#!/bin/sh

#   -------------------------------------------------------------
#   Install Arcanist for operations
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

set -e

ARC_DIR=/opt/phabricator
BIN_DIR=/usr/local/bin

#   -------------------------------------------------------------
#   Clone repositories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mkdir -p "$ARC_DIR"
cd "$ARC_DIR"

git clone https://github.com/nasqueron/arcanist.git
git clone https://github.com/nasqueron/shellcheck-linter.git

#   -------------------------------------------------------------
#   Provide symlink
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ln -s "$ARC_DIR/arcanist/bin/arc" "$BIN_DIR/arc"

#   -------------------------------------------------------------
#   Check prerequisites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

command -v php > /dev/null || echo ⚠️ You also need to install PHP to use Arcanist.
