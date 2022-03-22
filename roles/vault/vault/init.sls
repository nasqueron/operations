#   -------------------------------------------------------------
#   Salt — Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set network = salt['node.resolve_network']() %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vault:
  pkg.installed

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/vault.hcl:
  file.managed:
    - source: salt://roles/vault/vault/files/vault.hcl
    - mode: 644
    - template: jinja
    - context:
        id: {{ grains['id'] }}
        ip: {{ network['ipv4_address'] }}
        certificates_available: {{ salt["file.file_exists"]("/usr/local/etc/certificates/vault") }}

#   -------------------------------------------------------------
#   Storage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/db/vault:
  file.directory:
    - mode: 700
    - user: vault
    - group: vault

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains["os"] == "FreeBSD" %}
/etc/rc.conf.d/vault/vault:
  file.managed:
    - makedirs: True
    - mode: 644
    - contents: |
        vault_enable="YES"
        vault_syslog_output_enable="YES"
{% endif %}

service_vault:
  service.running:
    - name: vault
    - enable: true
