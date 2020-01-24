#   -------------------------------------------------------------
#   Salt — Salt master configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-04-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Accounts
#   -------------------------------------------------------------

# Salt account
salt_account:
  group.present:
    - name: salt
    - gid: 9001
  user.present:
    - name: salt
    - fullname: SaltStack master account
    - uid: 9001
    - gid: 9001
    - home: /var/run/salt

salt_account_ownership:
    cmd.run:
      - name: chown -R salt {{ dirs.etc }}/salt /var/cache/salt /var/log/salt /var/run/salt
      - onchanges:
        - user: salt_account

# Deployment account
deploy_account:
  user.present:
    - name: deploy
    - fullname: Deployment and management of the Salt staging area
    - uid: 9002
    - gid: 3003
    - home: /var/run/deploy

#   -------------------------------------------------------------
#   SSH key for deployment account
#
#   This key should be added to:
#
#  - zemke-rhyne account on devcentral
#    https://devcentral.nasqueron.org/settings/user/zemke-rhyne/page/ssh/
#
#  - alken-orin account on GitHub
#    Credentials are stored in DevCentral passphrase application
#   -------------------------------------------------------------

/opt/salt/security:
  file.directory:
    - user: deploy
    - group: ops
    - chmod: 770

deploy_account_ssh_key:
  cmd.run:
    - name: ssh-keygen -t ed25519 -N "" -f /opt/salt/security/id_ed25519
    - runas: deploy
    - creates: /opt/salt/security/id_ed25519

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Ops should be able to sudo -u salt …
#   Deployers should be able to sudo -u deploy <anything>
#   -------------------------------------------------------------

{% for sudofile in ['salt', 'deploy'] %}
saltmaster_sudo_capabilities_{{ sudofile }}:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/{{ sudofile }}
    - source: salt://roles/saltmaster/account/files/{{ sudofile }}
{% endfor %}
