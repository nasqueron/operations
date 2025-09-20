#   -------------------------------------------------------------
#   NetBox
#   -------------------------------------------------------------
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set db = pillar["netbox"]["db"] %}
{% set secret_key = pillar["netbox"]["secret_key"] %}

/srv/netbox/netbox/netbox/netbox/configuration.py:
  file.managed:
    - source: salt://roles/netbox/netbox/files/configuration.py
    - mode: 400
    - user: netbox
    - group: netbox
    - template: jinja
    - context:
        db:
          name: {{ db["name"] }}
          user: {{ salt["credentials.get_username"](db["credential"]) }}
          password: {{ salt["credentials.get_password"](db["credential"]) }}
          host: {{ db["host"] }}
        secret_key: {{ salt["credentials.get_password"](secret_key) }}

#   -------------------------------------------------------------
#   WSGI configuration
#   -------------------------------------------------------------

/srv/netbox/gunicorn.py:
  file.managed:
    - source: salt://roles/netbox/netbox/files/gunicorn.py
    - mode: 644
    - template: jinja
    - context:
        app_port: {{ pillar["netbox"]["app_port"] }}

/var/log/netbox:
  file.directory:
    - user: netbox
    - group: netbox
    - mode: 755
