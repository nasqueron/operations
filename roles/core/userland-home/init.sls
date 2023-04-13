#   -------------------------------------------------------------
#   Salt — Provision dotfiles and other personal content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Note:           Content deployed here propagate to every server,
#                   for devserver only, see roles/devserver unit.
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{% for username, user in salt['forest.get_users']().items() %}
{% set tasks = user.get('everywhere_tasks', []) %}

{% if 'deploy_dotfiles' in tasks %}
dotfiles_to_core_{{ username }}:
  file.recurse:
    - name: /home/{{ username }}
    - source: salt://roles/core/userland-home/files/{{ username }}
    - include_empty: True
    - clean: False
    - user: {{ username }}
    - group: {{ username }}
    - template: jinja
    - context:
        roles: {{ salt["node.get"]("roles") }}
        node: {{ grains["id"] }}
{% endif %}

{% endfor %}
