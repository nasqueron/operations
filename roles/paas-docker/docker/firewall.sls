#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-05-24
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, services with context %}

#   -------------------------------------------------------------
#   Firewalld
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services['firewall'] == 'firewalld' %}

{{ dirs.etc }}/firewalld/zones/public.xml:
  file.managed:
    - source: salt://roles/paas-docker/docker/files/firewalld-zones-public.xml.jinja
    - template: jinja
    - context:
        subnets: {{ salt['paas_docker.get_subnets']() }}

firewalld_trust_docker_bridge:
  firewalld.present:
    - name: trusted
    - interfaces:
      - docker0

{% endif %}
