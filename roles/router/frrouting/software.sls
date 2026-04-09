#   -------------------------------------------------------------
#   Salt — Router — FRRouting
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   Install FRRouting
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ packages.frrouting }}:
  pkg.installed
