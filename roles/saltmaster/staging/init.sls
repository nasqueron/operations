#   -------------------------------------------------------------
#   Salt — Provision a salt master
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-21
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Git repositories for the staging area
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

staging_public_repository:
  file.directory:
    - name: /opt/salt/staging
    - user: deploy
    - group: deploy
    - dir_mode: 775
  git.latest:
    - name: https://devcentral.nasqueron.org/source/staging.git
    - target: /opt/salt/staging
    - user: deploy
    - update_head: False
    - submodules: True

staging_private_repository:
  file.directory:
    - name: /opt/salt/private/staging
    - user: deploy
    - group: deploy
    - dir_mode: 770
  git.latest:
    - name: ssh://vcs@devcentral.nasqueron.org:5022/source/private-staging.git
    - target: /opt/salt/private/staging
    - user: deploy
    - identity: /opt/salt/security/id_ed25519
    - update_head: False
    - submodules: True
