#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-07
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% for instance, container in pillar['docker_containers']['bugzilla'].items() %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/bugzilla
    - networks:
      - {{ container['network'] }}
    - environment:
        DB_HOST: {{ container['mysql']['host'] }}
        DB_DATABASE: {{ container['mysql']['db'] }}
        DB_USER: {{ salt['credentials.get_username'](container['credential']) }}
        DB_PASSWORD: {{ salt['credentials.get_password'](container['credential']) }}
        BUGZILLA_URL: https://{{ container['host'] }}/
    - ports:
      - 80
    - port_bindings:
      - {{ container['app_port'] }}:80

{% endfor %}
