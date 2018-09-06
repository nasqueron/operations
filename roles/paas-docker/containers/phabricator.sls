#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-06
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance in containers['phabricator'] %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}:
  file.directory:
    - user: 431
    - group: 433
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}_data:
  selinux.fcontext_policy_present:
    - name: /srv/{{  instance }}
    - sel_type: svirt_sandbox_file_t

selinux_context_{{ instance }}_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/{{ instance }}
{% endif %}

{% endfor %}
