#   -------------------------------------------------------------
#   Salt — Provision dotfiles and other personal content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% for username, user in salt['forest.get_users']().items() %}
{% if 'deploy_dotfiles_to_devserver' in user %}
dotfiles_to_devserver_{{username}}:
  file.recurse:
    - name: /home/{{ username }}
    - source: salt://roles/devserver/userland-home/files/dereckson
    - include_empty: True
    - clean: False
    - user: {{ username }}
    - group: {{ username }}
{% endif %}
{% endfor %}
