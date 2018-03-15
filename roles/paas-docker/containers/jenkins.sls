#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

#   -------------------------------------------------------------
#   Home directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/jenkins/jenkins_home:
  file.directory:
    - user: 1000
    - group: 1000
    - makedirs: True

{% if has_selinux %}
selinux_context_jenkins_home:
  selinux.fcontext_policy_present:
    - name: /srv/jenkins/jenkins_home
    - sel_type: svirt_sandbox_file_t

selinux_context_jenkins_home_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/jenkins/jenkins_home
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

jenkins:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: jenkinsci/jenkins
    - binds: /srv/jenkins/jenkins_home:/var/jenkins_home
    - ports:
      - 8080
      - 50000
    - port_bindings:
      - 38080:8080 # HTTP
      - 50000:50000 # Jenkins master's port for JNLP-based Jenkins agents
