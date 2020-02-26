#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set images = salt['node.filter_by_name']('docker_images') %}

#   -------------------------------------------------------------
#   Fetch Docker images
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for image in images %}
{{ image }}:
  docker_image.present
{% endfor %}
