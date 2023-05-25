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
