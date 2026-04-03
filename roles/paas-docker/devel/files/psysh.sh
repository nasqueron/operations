#!/bin/sh

#   -------------------------------------------------------------
#   PsySH container wrapper
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Wrapper to run PsySH as a Docker container
#   License:        Trivial work, not eligible to copyright
#   Image:          nasqueron/php-cli
#   -------------------------------------------------------------

docker run -it --rm nasqueron/php-cli psysh
