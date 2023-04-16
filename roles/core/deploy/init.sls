#   -------------------------------------------------------------
#   Salt — Deploy user
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt["node.has_deployment"]() %}

# Deployment account
deploy_account:
  user.present:
    - name: deploy
    - fullname: Deployment and management of the Salt staging area
    - uid: 9002
    - gid: 3003
    - home: /var/run/deploy

{% endif %}
