#   -------------------------------------------------------------
#   Salt — Shell server's units
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, services with context %}

#   -------------------------------------------------------------
#   Vault server configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/vault.d:
   file.absent

{{ dirs.etc }}/vault.hcl:
  file.managed:
    - source: salt://roles/shellserver/vault/files/vault.hcl
    - mode: 644
    - template: jinja
    - context:
        certificates_dir: {{ dirs.etc }}/certificates/vault
        id: {{ grains['id'] }}

#   -------------------------------------------------------------
#   Vault directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/db/vault:
  file.directory:
    - user: vault
    - group: vault
    - mode: 700
    - makedirs: True

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services['manager'] == 'systemd' %}
/lib/systemd/system/vault.service:
  file.managed:
    - source: salt://roles/shellserver/vault/files/vault.service
{% endif %}
