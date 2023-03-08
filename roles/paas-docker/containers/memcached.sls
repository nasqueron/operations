#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['memcached'].items() %}
{% set image = salt['paas_docker.get_image']("memcached", container) %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: {{ image }}
    - healthcheck:
        Test:
          - CMD-SHELL
          - echo stats | nc 127.0.0.1 11211
        Interval: 30000000000
{% if 'network' in container %}
    - networks:
      - {{ container['network'] }}
{% endif %}

{% endfor %}
