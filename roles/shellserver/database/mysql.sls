#   -------------------------------------------------------------
#   Salt — Provision MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2017-01-23
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Software
#   -------------------------------------------------------------

mysql:
  pkg:
    - installed
    - pkgs:
      {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
      - mariadb-server
      {% elif grains['os'] == 'FreeBSD' %}
      - mariadb101-server
      {% endif %}

full_text_search_stopwords_file:
  file.managed:
    - name: /opt/stopwords.txt
    - source: salt://roles/shellserver/database/files/stopwords.txt

mysql_config:
  file.managed:
    {% if grains['os'] == 'FreeBSD' %}
    - name: /usr/local/etc/my.cnf
    {% else %}
    - name: /etc/my.cnf
    {% endif %}
    - source: salt://roles/shellserver/database/files/my.cnf
