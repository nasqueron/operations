#   -------------------------------------------------------------
#   Deploy user repositories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Clone user repositories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, user in salt['forest.get_users']().items() %}

{% set repositories = salt['pillar.get']('user_repositories:' + username, {}) %}

{% for target, repo in repositories.items() %}
{{ target }}:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
  {{ repo['vcs'] | default('git') }}.latest:
    - name: {{ repo['source'] }}
    - target: {{ target }}
    - update_head: False
    {% if salt['node.has_role']('saltmaster') %}
    # TODO: find an alternative solution for other servers (suggest rSTAGING?)
    - identity: /opt/salt/security/id_ed25519
    {% endif %}

{% endfor %}

{% endfor %}
