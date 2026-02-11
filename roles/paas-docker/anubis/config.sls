#   -------------------------------------------------------------
#   Salt — Anubis (WAF/Reverse Proxy)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Global configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/anubis/private.key:
  file.managed:
    - source: salt://roles/paas-docker/anubis/files/private.key
    - template: jinja
    - context:
        key: {{ salt["credentials.get_password"]("anubis/" + grains["id"]) }}
    - user: anubis
    - group: anubis
    - mode: 400
    - makedirs: True

{{ dirs.etc }}/anubis/policies.yaml:
  file.managed:
    - source: salt://roles/paas-docker/anubis/files/policies.yaml
    - user: root
    - group: anubis
    - mode: 644
    - makedirs: True

#   -------------------------------------------------------------
#   Per-instance configuration and service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for instance, config in salt["pillar.get"]("anubis_instances", {}).items() %}

{{ dirs.etc }}/anubis/{{ instance }}/instance.env:
  file.managed:
    - source: salt://roles/paas-docker/anubis/files/instance.env
    - template: jinja
    - context:
        instance: {{ instance }}
        config: {{ config }}
        port: {{ pillar["docker_containers"][config.target.service][config.target.container]["app_port"] }}
    - user: root
    - group: anubis
    - mode: 644
    - makedirs: True

# e.g. systemctl status anubis@devcentral

/etc/systemd/system/anubis@{{ instance }}.service:
  file.managed:
    - source: salt://roles/paas-docker/anubis/files/anubis.service
    - template: jinja
    - context:
        instance: {{ instance }}

anubis@{{ instance }}:
  service.running:
    - enable: True
    - watch:
      - file: {{ dirs.etc }}/anubis/{{ instance }}/instance.env
      - file: {{ dirs.etc }}/anubis/policies.yaml
      - file: {{ dirs.etc }}/anubis/private.key

{% endfor %}
