#   -------------------------------------------------------------
#   Salt — Provision www.eglide.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-09-12
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Deploy /opt/staging/wwwroot/eglide.org/www to www.eglide.org
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/www/html:
  file.recurse:
    - source: salt://wwwroot/eglide.org/www
    - exclude_pat: E@.git
    - include_empty: True
    - clean: True
    - user: www-data
    - group: www-data
    - dir_mode: 711
    - file_mode: 644
