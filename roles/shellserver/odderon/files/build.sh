#   -------------------------------------------------------------
#   Salt — Deploy Odderon (darkbot)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-25
#   Authors:        David Seikel, Dereckson
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

PREFIX=/opt/odderon

test ! -r build/configure && sh bootstrap.sh

cd build
sh configure -C --prefix=$PREFIX "$@"
make
