#   -------------------------------------------------------------
#   Salt — Provision api.nasqueron.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has_web_content'](".org/nasqueron/api") %}

#   -------------------------------------------------------------
#   Base part from rOPS
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/api:
  file.recurse:
    - source: salt://wwwroot/nasqueron.org/api
    - exclude_pat: E@.git
    - include_empty: True
    - clean: False
    - dir_mode: 755
    - file_mode: 644
    - user: deploy
    - group: web

#   -------------------------------------------------------------
#   API micro services are deployed to /srv/api
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/api:
  file.directory:
    - user: deploy
    - group: web
    - dir_mode: 755

/srv/api/data:
  file.directory:
    - user: deploy
    - group: web
    - dir_mode: 755

#   -------------------------------------------------------------
#   /servers-log micro service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/api/servers-log:
  file.recurse:
    - source: salt://software/api/serverslog
    - exclude_pat: E@.git
    - include_empty: True
    - clean: False
    - dir_mode: 755
    - file_mode: 644
    - user: deploy
    - group: web

api_servers_log_dependencies:
  cmd.run:
    - name: composer install
    - runas: deploy
    - cwd: /srv/api/servers-log
    - creates: /srv/api/servers-log/vendor

/srv/api/data/servers-log-all.json:
  file.managed:
    - user: web-org-nasqueron-api-serverslog
    - mode: 644

{% endif %}
