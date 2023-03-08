#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% for instance, container in pillar['docker_containers']['tommy'].items() %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/tommy
    - environment:
        - JENKINS_URL: {{ container['jenkins_url'] }}
        {% if "jenkins_multi_branch" in container %}
        # We don't use default value, as Ruby idea of truthy is pretty large, including 0
        - JENKINS_MULTI_BRANCH: {{ container['jenkins_multi_branch'] }}
        {% endif %}
    - ports:
      - 4567
    - port_bindings:
      - {{ container['app_port'] }}:4567 # HTTP

{% endfor %}
