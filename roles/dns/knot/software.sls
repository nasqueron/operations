#   -------------------------------------------------------------
#   Salt — KnotDNS software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

knotdns_software:
  pkg.installed:
    - name: knot3
