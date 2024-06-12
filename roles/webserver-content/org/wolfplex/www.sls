#   -------------------------------------------------------------
#   Salt — Provision www.wolfplex.org static subdirectories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-22
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/var/wwwroot/wolfplex.org/www/2013:
  file.recurse:
    - source: salt://software/wolfplex/web-campaigns-2013
    - exclude_pat: E@.git
    - include_empty: True
    - clean: True
    - dir_mode: 755
    - file_mode: 644
    - user: wolfplex.org
    - group: web

/var/dataroot/wolfplex:
  file.directory:
    - user: web-org-wolfplex-www
    - group: web
