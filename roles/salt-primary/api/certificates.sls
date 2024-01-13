#   -------------------------------------------------------------
#   Salt — Provision a salt primary server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Copy TLS certificates from Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/certificates/salt-api:
  file.directory:
    - user: salt
    - mode: 755
    - makedirs: True

{{ dirs.etc }}/certificates/salt-api/fullchain.pem:
  file.managed:
    - user: salt
    - mode: 444
    - source: /usr/local/etc/certificates/vault/fullchain.pem

{{ dirs.etc }}/certificates/salt-api/private.key:
  file.managed:
    - user: salt
    - mode: 400
    - source: /usr/local/etc/certificates/vault/private.key
