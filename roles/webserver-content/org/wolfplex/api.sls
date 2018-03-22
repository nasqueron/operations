#   -------------------------------------------------------------
#   Salt — Provision api.wolfplex.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wolfplex
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has_web_content'](".org/wolfplex/api") %}

#   -------------------------------------------------------------
#   Base part
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/wolfplex.org/api:
  file.recurse:
    - source: salt://wwwroot/wolfplex.org/api
    - exclude_pat: E@.git
    - include_empty: True
    - clean: False
    - dir_mode: 755
    - file_mode: 644
    - user: web-org-wolfplex-www
    - group: web

#   -------------------------------------------------------------
#   Deployment
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

wolfplex_api_dependencies:
  cmd.run:
    - name: composer install
    - runas: web-org-wolfplex-www
    - cwd: /var/wwwroot/wolfplex.org/api
    - creates: /var/wwwroot/wolfplex.org/api/vendor

wolfplex_api_kibaone_accents:
  cmd.run:
    - name: make
    - runas: web-org-wolfplex-www
    - cwd: /var/wwwroot/wolfplex.org/api/design/kibaone/accents
    - creates: /var/wwwroot/wolfplex.org/api/design/kibaone/accents/index.json

{% endif %}
