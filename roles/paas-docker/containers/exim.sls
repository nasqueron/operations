#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-11-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['exim'].items() %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/exim/{{ instance }}:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

{% for subdir in ['spool', 'log'] %}
/srv/exim/{{ instance }}/{{ subdir }}:
  file.directory:
    - user: 999
    - group: 999
{% endfor %}

{% if 'mailname' in container %}
/srv/exim/{{ instance }}/mailname:
  file.managed:
    - contents: {{ container['mailname'] }}
{% endif %}

{% if has_selinux %}

selinux_context_{{ instance }}_exim_data:
  selinux.fcontext_policy_present:
    - name: /srv/exim/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_exim_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/exim/{{ instance }}

{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: tianon/exim4
    - binds:
{% if 'mailname' in container %}
        - /srv/exim/{{ instance }}/mailname:/etc/mailname:ro
{% endif %}
        - /srv/exim/{{ instance }}/spool:/var/spool/exim4
        - /srv/exim/{{ instance }}/log:/var/log/exim4
{% if 'host' in container %}
    - hostname: {{ container['mailname'] }}
{% endif %}
{% if 'network' in container %}
    - networks:
      - {{ container['network'] }}
{% endif %}

{% endfor %}
