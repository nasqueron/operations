#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt["grains.get"]("selinux:enabled", False) %}
{% set containers = pillar["docker_containers"] %}

{% for instance, container in containers["vault"].items() %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for dir in ["config", "config/certificates", "storage"] %}

/srv/vault/{{ instance }}/{{ dir }}:
  file.directory:
    - user: 100
    - group: 1000
    - makedirs: True

{% endfor %}

/srv/vault/{{ instance }}/config/vault.hcl:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/vault/vault.hcl
    - mode: 644
    - template: jinja
    - context:
        id: {{ instance }}

{% if has_selinux %}
selinux_context_vault_data_{{ instance }}:
  selinux.fcontext_policy_present:
    - name: /srv/vault/{{ instance }}
    - sel_type: container_file_t

selinux_context_vault_data_applied_{{ instance }}:
  selinux.fcontext_policy_applied:
    - name: /srv/vault/{{ instance }}
    - recursive: True
{% endif %}

#   -------------------------------------------------------------
#   Container
#
#   Image:          hashicorp/vault
#   Description:    Vault
#   Services used:  Docker volume
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: hashicorp/vault
    - command: server
    - cap_add:
      - IPC_LOCK
    - binds:
      - /srv/vault/{{ instance }}/config:/vault/config
      - /srv/vault/{{ instance }}/storage:/vault/storage
    - networks:
      - {{ container["network"] }}
    - environment:
        - VAULT_CLUSTER_INTERFACE: eth0
        - VAULT_REDIRECT_INTERFACE: eth0
    - ports:
        - 8200
    - port_bindings:
        - {{ container["ip"] }}:{{ container["app_port"] }}:8200

{% endfor %}
