#   -------------------------------------------------------------
#   Salt — Deploy user
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt["node.has_deployment"]() %}
{% set uids = pillar["uids"] %}
{% set gids = pillar["gids"] %}

# Deployment account
deploy_account:
  user.present:
    - name: deploy
    - fullname: Deployment and management of the Salt staging area
    - uid: {{ uids["deploy"] }}
    - gid: {{ gids["deployment"] }}
    - home: /var/run/deploy

{% endif %}
