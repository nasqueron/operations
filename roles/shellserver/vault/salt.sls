#   -------------------------------------------------------------
#   Salt — Shell server's units
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% from "roles/core/certificates/map.jinja" import certificates with context %}

#   -------------------------------------------------------------
#   Salt configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/salt/minion.d/vault.conf:
  file.managed:
    - source: salt://roles/shellserver/vault/files/salt-vault.conf
    - mode: 400
    - replace: False
    - show_changes: False
    - makedirs: True
    - template: jinja
    - context:
        url: https://127.0.0.1:8200
        certificate: {{ certificates.dir }}/nasqueron-vault-ca.crt
