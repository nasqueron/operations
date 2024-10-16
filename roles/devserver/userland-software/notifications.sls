#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-02-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/notifications:
  file.managed:
    - source: salt://software/notifications-cli-client/notifications
    - mode: 755

#   -------------------------------------------------------------
#   Dependencies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

notifications_dependencies:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.python3 }}pika

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/etc/notifications.conf:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/notifications.conf
    - group: nasquenautes
    - mode: 640
    - template: jinja
    - context:
        host: {{ pillar["nasqueron_services"]["docker"]["notifications"] }}
        password: {{ salt['credentials.get_password']("nasqueron/notifications/notifications-cli/" + grains["id"]) }}
