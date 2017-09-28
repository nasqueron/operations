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
#   Deployers should be able to sudo -u deploy <anything>
#   -------------------------------------------------------------

{% for sudofile in ['salt', 'deploy'] %}
saltmaster_sudo_capabilities_{{ sudofile }}:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/{{ sudofile }}
    - source: salt://roles/saltmaster/sudo/files/{{ sudofile }}
{% endfor %}
