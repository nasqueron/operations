#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set images = salt['paas_docker.list_images']() %}

#   -------------------------------------------------------------
#   Fetch Docker images
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for image in images %}
{{ image }}:
  docker_image.present
{% endfor %}
