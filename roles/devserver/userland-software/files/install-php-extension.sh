#!/bin/sh

#   -------------------------------------------------------------
#   Intall PHP extension
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Author:         Sébastien Santoro aka Dereckson
#   Created:        2018-03-29
#   License:        BSD-2-Clause
#   Source file:    roles/devserver/userland-software/files/install-php-extension.sh
#   -------------------------------------------------------------

AS_BUILDER=sudo -u builder

$AS_BUILDER phpize
$AS_BUILDER ./configure
$AS_BUILDER make
