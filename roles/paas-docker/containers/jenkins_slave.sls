#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

#   -------------------------------------------------------------
#   Home directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/jenkins/slave_home:
  file.directory:
    - user: 431
    - group: 433
    - makedirs: True

{% if has_selinux %}
selinux_context_jenkins_slave_home:
  selinux.fcontext_policy_present:
    - name: /srv/jenkins/slave_home
    - sel_type: svirt_sandbox_file_t

selinux_context_jenkins_slave_home_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/jenkins/slave_home
{% endif %}

/srv/jenkins/slave_home/.ssh:
  file.directory:
      - user: 431
      - group: 433

/srv/jenkins/slave_home/.ssh/authorized_keys:
  file.managed:
      - source: salt://roles/paas-docker/containers/files/jenkins_slave/authorized_keys
      - user: 431
      - group: 433

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for instance, container in containers['jenkins_slave'].items() %}
{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/jenkins-slave-php
    - binds: /srv/jenkins/slave_home:/home/app
    - networks:
      - {{ container['network'] }}
{% endfor %}
