#   -------------------------------------------------------------
#   Salt — sudo configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-19
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Ops should be able to sudo …
#   -------------------------------------------------------------

{{ dirs.etc }}/sudoers.d/ops:
  file.managed:
    - source: salt://roles/core/sudo/files/ops
