#   -------------------------------------------------------------
#   Salt — Provision dovecot Config
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set db = pillar["dovecot_config"]["db"] %}

dovecot:
  pkg.installed

{{ dirs.etc }}/dovecot/conf.d:
  file.directory:
    - mode: 755
    - user: root
    - group: wheel
    - makedirs: True

{{ dirs.etc }}/dovecot/dovecot.conf:
  file.managed:
    - source: salt://roles/mailserver/dovecot/files/dovecot.conf
    - template: jinja

{{ dirs.etc }}/dovecot/dovecot-sql.conf.ext:
  file.managed:
    - source: salt://roles/mailserver/dovecot/files/dovecot-sql.conf.ext
    - template: jinja
    - mode: 400
    - context:
        db:
          hostname: {{ pillar["nasqueron_services"][db["service"]] }}
          name: {{ db["database"] }}
          password: {{ salt["credentials.get_password"](db["credential"]) }}
          user: {{ salt["credentials.get_username"](db["credential"]) }}

dovecot_file_config_conf_d:
  file.recurse:
    - source: salt://roles/mailserver/dovecot/files/conf.d
    - name: {{ dirs.etc }}/dovecot/conf.d
    - file_mode: 755
    - dir_mode: 755
    - context:
        mailbox:
          dir: /var/mail/_virtual

dovecot_running:
  service.running:
    - name: dovecot
    - enable: True
