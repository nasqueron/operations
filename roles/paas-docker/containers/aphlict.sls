#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-07
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% for instance, container in pillar['docker_containers']['aphlict'].items() %}

#   -------------------------------------------------------------
#   Container
#
#   Image:          nasqueron/aphlict
#   Description:    Node application to get real time notifications
#                   through websockets for Phabricator instances.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/aphlict
    - ports:
      - 22280
      - 22281
    - port_bindings:
      - {{ container['ports']['client'] }}:22280
      - {{ container['ports']['admin'] }}:22281

{% endfor %}
