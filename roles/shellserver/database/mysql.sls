#   -------------------------------------------------------------
#   Salt — Provision MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2017-01-23
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages with context %}

#   -------------------------------------------------------------
#   Software
#   -------------------------------------------------------------

mysql:
  pkg:
    - installed
    - pkgs:
      - {{ packages.mariadb }}

full_text_search_stopwords_file:
  file.managed:
    - name: /opt/stopwords.txt
    - source: salt://roles/shellserver/database/files/stopwords.txt

mysql_config:
  file.managed:
    - name: {{ dirs.etc }}/my.cnf
    - source: salt://roles/shellserver/database/files/my.cnf
