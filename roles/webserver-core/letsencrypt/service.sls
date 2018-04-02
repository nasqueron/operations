#   -------------------------------------------------------------
#   Salt — Let's encrypt certificates
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-04-27
#   Description:    Provide a renewal service
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import services with context %}

#   -------------------------------------------------------------
#   Renew script
#   -------------------------------------------------------------

/usr/local/sbin/letsencrypt-renewal:
  file.managed:
    - source: salt://roles/webserver-core/letsencrypt/files/letsencrypt-renewal.sh
    - mode: 0755

#   -------------------------------------------------------------
#   Unit configuration
#   -------------------------------------------------------------

{% if services['manager'] == 'systemd' %}

letsencrypt_renew_unit:
  file.managed:
    - name: /etc/systemd/system/letsencrypt-renew.service
    - source: salt://roles/webserver-core/letsencrypt/files/letsencrypt-renew.service
    - mode: 0644
  module.run:
    - service.force_reload:
      - name: letsencrypt-renew
    - onchanges:
       - file: letsencrypt_renew_unit

letsencrypt_renew_enable:
  service.enabled:
    - name: letsencrypt-renew
    - watch:
      - module: letsencrypt_renew_unit

{% endif %}
