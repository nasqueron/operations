#   -------------------------------------------------------------
#   Salt — Salt master configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-04-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Ops should be able to sudo -u salt …
#   -------------------------------------------------------------

saltmaster_sudo_capabilities_file:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/salt
    - source: salt://roles/saltmaster/sudo/files/salt
