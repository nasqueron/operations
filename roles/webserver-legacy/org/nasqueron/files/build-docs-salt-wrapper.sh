#!/bin/sh

# The salt-wrapper documentation is stored in the main repository
git clone https://devcentral.nasqueron.org/source/salt-wrapper.git

# Build documentation
cd salt-wrapper/docs || exit 1
make html

# Deploy
mv _build/html/* "$1"

# Clean
cd ../.. || exit 2
rm -rf salt-wrapper
