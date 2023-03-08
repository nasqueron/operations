#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-11-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['postgresql'].items() %}
{% set image = salt['paas_docker.get_image']("library/postgres", container) %}

  #   -------------------------------------------------------------
  #   Home directory
  #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}/postgresql:
  file.directory:
  - user: 999
  - group: 999
  - makedirs: True

{% if has_selinux %}

selinux_context_{{ instance }}_postgresql_data:
  selinux.fcontext_policy_present:
  - name: /srv/{{ instance }}/postgresql
  - sel_type: container_file_t

selinux_context_{{ instance }}_postgresql_data_applied:
  selinux.fcontext_policy_applied:
  - name: /srv/{{ instance }}/postgresql

{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: {{ image }}
    - binds: /srv/{{ instance }}/postgresql:/var/lib/postgresql/data
    - environment:
        POSTGRES_USER: {{ salt['credentials.get_username'](container['credential']) }}
        POSTGRES_PASSWORD: {{ salt['credentials.get_password'](container['credential']) }}
{% if 'network' in container %}
    - networks:
      - {{ container['network'] }}
{% endif %}

{% endfor %}
