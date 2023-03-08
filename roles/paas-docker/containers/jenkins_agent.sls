#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['jenkins_agent'].items() %}

{% set realm = pillar['jenkins_realms'][container['realm']] %}
{% set home = "/srv/jenkins/" + container['realm'] + "/agents_homes/" + instance %}
{% set image = pillar['jenkins_images'][container['image_flavour']] %}
{% set image = salt['paas_docker.get_image'](image, container) %}

#   -------------------------------------------------------------
#   Home directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ home }}:
  file.directory:
    - user: 431
    - group: 433
    - makedirs: True

{% if has_selinux %}
selinux_context_jenkins_agent_{{  instance }}_home:
  selinux.fcontext_policy_present:
    - name: {{ home }}
    - sel_type: container_file_t

selinux_context_jenkins_agent_{{  instance }}_home_applied:
  selinux.fcontext_policy_applied:
    - name: {{ home }}
{% endif %}

{{ home }}/.ssh:
  file.directory:
      - user: 431
      - group: 433

{{ home }}/.ssh/authorized_keys:
  file.managed:
      - contents: {{ realm['ssh_key'] }}
      - user: 431
      - group: 433

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: {{ image }}
    - binds: {{ home }}:/home/app
    - networks:
      - {{ realm['network'] }}

{% endfor %}
