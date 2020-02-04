#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-02-04
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['acme_dns'].items() %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}:
  file.directory:
    - makedirs: True

/srv/{{ instance }}/etc:
  file.directory

/srv/{{ instance }}/lib:
  file.directory

{% if has_selinux %}
selinux_context_openfire_data:
  selinux.fcontext_policy_present:
    - name: /srv/{{ instance }}
    - sel_type: container_file_t

selinux_context_openfire_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}/etc/config.cfg:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/acme/config.cfg
    - template: jinja
    - context:
        ip: {{ container['ip'] }}
        domain: {{ container['host'] }}
        nsadmin: {{ container['nsadmin'] }}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: joohoi/acme-dns
    - binds:
      - /srv/{{ instance }}/etc:/etc/acme-dns:ro
      - /srv/{{ instance }}/lib:/var/lib/acme-dns
    - ports:
      - 53
      - 53/udp
      - 80
    - port_bindings:
      - 53:53
      - 53:53/udp
      - 127.0.0.1:{{ container['app_port'] }}:80

{% endfor %}
