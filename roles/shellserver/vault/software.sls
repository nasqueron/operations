#   -------------------------------------------------------------
#   Salt — Shell server's units
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   HashiCorp repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains["os_family"] == "Debian" %}

/usr/share/keyrings/hashicorp-archive-keyring.gpg:
  file.managed:
    - source: salt://roles/shellserver/vault/files/hashicorp-archive-keyring.gpg
    - mode: 644

/etc/apt/sources.list.d/hashicorp.list:
  file.managed:
    - source: salt://roles/shellserver/vault/files/hashicorp.list
    - mode: 644

{% endif %}

#   -------------------------------------------------------------
#   Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vault:
  pkg.installed
