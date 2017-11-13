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

# Allow to repair ownership if the account is created after the staging
deploy_account_ownership:
  cmd.run:
    - name: chown -R salt /opt/salt/staging /opt/salt/private/staging
    - onchanges:
      - user: deploy_account

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
