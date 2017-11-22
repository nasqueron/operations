#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% for dir in salt['pillar.get']('web_autochmod', []) %}

autochmod_{{ dir }}:
  cmd.run:
    - name: autochmod
    - cwd: {{ dir }}

{% endfor %}
