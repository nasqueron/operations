#!/bin/sh -e

#   -------------------------------------------------------------
#   rc.local
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-06-15
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/core/rc/files/rc.local.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

#   -------------------------------------------------------------
#   IPv6
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/sbin/ipv6-setup-tunnel

#   -------------------------------------------------------------
#   Return value
#
#   Should be 0 on success, not 0 on failure. Current rc process
#   requires this value to be set accordingly.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit 0
