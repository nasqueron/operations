#   -------------------------------------------------------------
#   Salt — sudo configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-19
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
sudo:
  pkg.installed
{% endif %}

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Ops should be able to sudo …
#   Acmesh should be able to sudo acmesh-nginxCheck
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/sudoers.d/ops:
  file.managed:
    - source: salt://roles/core/sudo/files/ops
    - makedirs: True

{{ dirs.etc }}/sudoers.d/acme:
  file.managed:
    - source: salt://roles/core/sudo/files/acme
    - template: jinja
    - makedirs: True
    - context:
        dirs: {{ dirs }}
