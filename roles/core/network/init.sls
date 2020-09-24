#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .ipv4
  - .ipv6
  - .private
  - .gre

# Drake can be configured as:
#
#   - private (e.g. IntraNought network cards on EXSi hypervisor VMs)
#   - gre     (e.g. isolated servers needing a tunnel)
#
# Both are needed for servers with router role.
