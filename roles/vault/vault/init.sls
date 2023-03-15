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

/opt/vault/vault.zip:
  file.managed:
    - source: https://releases.hashicorp.com/vault/1.13.0/vault_1.13.0_freebsd_amd64.zip
    - source_hash: 0d5c0e228f9783cb2f11e7edb9afe35b8d9e511a2fa0d35d0f650b3e261ce1a5
    - makedirs: True

extract_vault:
  cmd.run:
    - name: unzip -d {{ dirs.bin }} -f /opt/vault/vault.zip
    - onchanges:
        - file: /opt/vault/vault.zip

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
        certificates_available: {{ salt["file.file_exists"]("/usr/local/etc/certificates/vault/fullchain.pem") }}

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
