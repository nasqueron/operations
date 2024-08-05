#   -------------------------------------------------------------
#   Salt — Salt configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-06-12
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% from "roles/core/certificates/map.jinja" import certificates with context %}

salt_roles:
  grains.list_present:
    - name: roles
    - value: {{ salt['node.get_list']("roles") }}

#   -------------------------------------------------------------
#   Repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'RedHat' %}
/etc/yum.repos.d/salt.repo:
  file.managed:
    - source: salt://roles/core/salt/files/salt.repo
{% endif %}

{% if grains['os_family'] == 'Debian' %}
/etc/apt/keyrings/salt-archive-keyring-2023.gpg:
  file.managed:
    - source: salt://roles/core/salt/files/SALT-PROJECT-GPG-PUBKEY-2023.gpg
    - makedirs: True

/etc/apt/sources.list.d/salt.list:
  file.managed:
    - source: salt://roles/core/salt/files/salt.list
    - makedirs: True
{% endif %}

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/salt_minion:
  file.managed:
    - source: salt://roles/core/salt/files/rc.conf
{% endif %}

#   -------------------------------------------------------------
#   Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/salt/minion.d/vault.conf:
  file.managed:
    - source: salt://roles/core/salt/files/vault.conf
    - template: jinja
    - context:
        certificate: {{ certificates.dir }}/nasqueron-vault-ca.crt
