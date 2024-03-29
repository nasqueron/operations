#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['jenkins'].items() %}

{% set realm = pillar['jenkins_realms'][container['realm']] %}
{% set home = "/srv/jenkins/" + container['realm'] + "/jenkins_home" %}

#   -------------------------------------------------------------
#   Home directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ home }}:
  file.directory:
    - user: 1000
    - group: 1000
    - makedirs: True

{% if has_selinux %}
selinux_context_jenkins_home_{{ instance }}:
  selinux.fcontext_policy_present:
    - name: {{ home }}
    - sel_type: container_file_t

selinux_context_jenkins_home_applied_{{ instance }}:
  selinux.fcontext_policy_applied:
    - name: {{ home }}
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: jenkins/jenkins
    - binds: {{ home }}:/var/jenkins_home
    - networks:
      - {{ realm['network'] }}
    - ports:
      - 8080
      - 50000
    - port_bindings:
      - {{ container['app_port'] }}:8080 # HTTP
      - {{ container['jnlp_port'] }}:50000 # Jenkins controller's port for JNLP-based Jenkins agents

{% endfor %}
