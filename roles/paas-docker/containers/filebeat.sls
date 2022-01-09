#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['filebeat'].items() %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/filebeat/{{ instance }}:
  file.directory:
    - user: 9001
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}_data:
  selinux.fcontext_policy_present:
    - name: /srv/filebeat/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/filebeat/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set with_cacert = 'cacert' in container['opensearch'] %}

/srv/filebeat/{{ instance }}/filebeat.yml:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/filebeat/filebeat.yml.jinja
    - mode: 0600
    - template: jinja
    - context:
        host: {{ grains['id'] }}
        forest: {{ salt['forest.get']() }}

        retention: {{ container['retention'] }}

        elastic: {{ container['opensearch'] }}
        elastic_username: {{ salt['zr.get_username'](container['credentials']['opensearch']) }}
        elastic_password: {{ salt['zr.get_password'](container['credentials']['opensearch']) }}
        with_cacert: {{ with_cacert }}

{% if with_cacert %}
/srv/filebeat/{{ instance }}/cacert.pem:
  file.managed:
    - contents: |
{% filter indent(width=8) %}
{{ container['opensearch']['cacert'] }}
{% endfilter %}
    - mode: 0644
{% endif %}

#   -------------------------------------------------------------
#   Container
#
#   To be compatible with OpenSearch, currently it's recommended
#   to use filebeat 7.10.2.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: docker.elastic.co/beats/filebeat-oss:7.10.2
    - user: root
    - binds:
      - /srv/filebeat/{{ instance }}/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
{% if with_cacert %}
      - /srv/filebeat/{{ instance }}/cacert.pem:/usr/share/filebeat/cacert.pem:ro
{% endif %}
      - /var/lib/docker:/var/lib/docker:ro
      - /var/run/docker.sock:/var/run/docker.sock

{%  endfor %}
