#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['jenkins'].items() %}

#   -------------------------------------------------------------
#   Home directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}/jenkins_home:
  file.directory:
    - user: 1000
    - group: 1000
    - makedirs: True

{% if has_selinux %}
selinux_context_jenkins_home:
  selinux.fcontext_policy_present:
    - name: /srv/{{ instance }}/jenkins_home
    - sel_type: svirt_sandbox_file_t

selinux_context_jenkins_home_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/{{ instance }}/jenkins_home
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: jenkinsci/jenkins
    - binds: /srv/{{ instance }}/jenkins_home:/var/jenkins_home
    - networks:
      - {{ container['network'] }}
    - ports:
      - 8080
      - 50000
    - port_bindings:
      - {{ container['app_port'] }}:8080 # HTTP
      - {{ container['jnlp_port'] }}:50000 # Jenkins master's port for JNLP-based Jenkins agents

{% endfor %}
