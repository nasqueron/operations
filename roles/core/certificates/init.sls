#   -------------------------------------------------------------
#   Salt - Deploy certificates
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "roles/core/certificates/map.jinja" import certificates with context %}

#   -------------------------------------------------------------
#   Certificates provided by trusted sources
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if "packages" in certificates %}

certificates_packages:
  pkg.installed:
    - pkgs: {{ certificates.packages }}

{% endif %}

#   -------------------------------------------------------------
#   Deploy Nasqueron certificates
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ certificates.dir }}:
  file.directory:
    - makedirs: True

# Vault PKI Root CA
# Used to sign intermediate authorities for 172.27.27.* services
{{ certificates.dir }}/nasqueron-vault-ca.crt:
  file.managed:
    - source: salt://roles/core/certificates/files/nasqueron-vault-ca.crt
    - mode: 444

{% if "update-store" in certificates %}

certificates_update_store:
  cmd.run:
    - name: {{ certificates.update-store }}
    - onchanges:
      - file: {{ certificates.dir }}/nasqueron-vault-ca.crt

{% endif %}
