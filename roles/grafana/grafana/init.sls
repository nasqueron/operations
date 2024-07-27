#   -------------------------------------------------------------
#   Salt — Provision Grafana
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

grafana:
  pkg.installed

#   -------------------------------------------------------------
#   Config
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/grafana/grafana.ini:
  file.managed:
    - source: salt://roles/grafana/grafana/files/grafana.ini
    - template: jinja
    - context:
        domain: grafana.nasqueron.org
        socket:
          dir: /var/run/web/grafana
          gid: 9003 # web

#   -------------------------------------------------------------
#   Socket
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/run/web/grafana:
  file.directory:
    - user: grafana
    - group: web

ensure_grafana_user_is_in_group_web:
  user.present:
    - name: grafana
    - groups:
        - web
    - remove_groups: False
    - createhome: False

#   -------------------------------------------------------------
#   Plugins access by nginx
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/lib/grafana:
  file.directory:
    - mode: 0751

/var/lib/grafana/plugins:
  file.directory:
    - user: grafana
    - group: web
    - mode: 0750

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

/etc/rc.conf.d/grafana:
  file.managed:
    - source: salt://roles/grafana/grafana/files/rc/grafana.conf
    - template: jinja

{% endif %}

grafana_running:
  service.running:
    - name: grafana
