#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-07
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Container
#
#   Image:          nasqueron/aphlict
#   Description:    Node application to get real time notifications
#                   through websockets for Phabricator instances.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

aphlict:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/aphlict
    - ports:
      - 22280
      - 22281
    - port_bindings:
      - 22280:22280
      - 22281:22281
