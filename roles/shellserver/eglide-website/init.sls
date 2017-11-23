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

{% set wwwroot = salt['node.get_wwwroot']() %}
{% set wwwuser = "www-data" %}
{% set wwwgroup = "www-data" %}

/var/{{ wwwroot }}:
  file.directory:
    - user: {{ wwwuser }}
    - group: {{ wwwgroup }}
    - dir_mode: 711
    - makedirs: True

wwwroot_server:
  file.recurse:
    - name: /var/{{ wwwroot }}
    - source: salt://{{ wwwroot }}
    - exclude_pat: E@.git
    - include_empty: True
    - clean: True
    - user: {{ wwwuser }}
    - group: {{ wwwgroup }}
    - dir_mode: 711
    - file_mode: 644

/var/wwwroot/paysannerebelle.com/robot/:
  file.directory:
    - user: hlp
    - group: {{ wwwgroup }}
    - dir_mode: 711
    - makedirs: True

#   -------------------------------------------------------------
#   Nginx logs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/log/www/eglide.org:
  file.directory:
    - user: root
    - group: {{ wwwgroup }}
    - dir_mode: 750

/var/log/www/paysannerebelle.com:
  file.directory:
    - user: hlp
    - group: {{ wwwgroup }}
    - dir_mode: 750
