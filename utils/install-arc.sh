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
#   Dependencies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_dependencies()
{
    if [ "$ID" = "debian" ] || [ "$ID_LIKE" = "debian" ]; then
        apt install git php php-curl php-dom shellcheck
    elif [ "$ID" = "freebsd" ]; then
        echo pkg install git php83 php83-curl php83-dom hs-ShellCheck
    elif [ "$ID" = "fedora" ]; then
        dnf install git php php-dom shellcheck
    elif [ "$ID" = "darwin" ]; then
        brew install git php shellcheck
    else
        echo "Can't detect OS, add a condition or a new block in install_dependencies. ID: '$ID'."
    fi
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
elif command -v brew; then
    # macOS doesn't use os-release, but we can still detect Homebrew
    ID=darwin
fi
install_dependencies

exit 0

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
