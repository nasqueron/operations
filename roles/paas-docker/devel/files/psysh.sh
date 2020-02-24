#!/bin/sh

#   -------------------------------------------------------------
#   PsySH container wrapper
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Author:         Sébastien Santoro aka Dereckson
#   Project:        Nasqueron
#   Created:        2020-02-24
#   Description:    Wrapper to run PsySH as a Docker container
#   License:        Trivial work, not eligible to copyright
#   Image:          nasqueron/php-cli
#   -------------------------------------------------------------

docker run -it --rm nasqueron/php-cli psysh
