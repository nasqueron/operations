#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['orbeon'].items() %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/orbeon/{{ instance }}:
  file.directory:
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}_data:
  selinux.fcontext_policy_present:
    - name: /srv/orbeon/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/orbeon/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/orbeon/{{ instance }}/conf/tomcat-users.xml:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/_tomcat/tomcat-users.xml
    - mode: 400
    - makedirs: True
    - template: jinja
    - show_changes: False
    - context:
        users:
          {% for user, credential in container["tomcat"]["users"].items() %}
          {{ user }}:
            password: {{ salt["credentials.get_password"](credential) | yaml_dquote }}
            roles:
              - orbeon-admin
          {% endfor %}

/srv/orbeon/{{ instance }}/conf/properties-local.xml:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/orbeon/{{ instance }}/properties-local.xml
    - mode: 400
    - template: jinja
    - show_changes: False
    - context:
        secret_key: {{ salt["credentials.get_password"](container["secret_key"]) | yaml_dquote }}
        host: {{ container["host"] }}
        smtp: {{ container["smtp"] }}

/srv/orbeon/{{ instance }}/conf/orbeon.xml:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/orbeon/server.xml
    - mode: 400
    - template: jinja
    - show_changes: False
    - context:
        db:
          host: {{ pillar["nasqueron_services"][container["db"]["service"]] }}
          database: {{ container["db"]["database"] }}
          user: {{ salt["credentials.get_username"](container["db"]["credential"]) }}
          pass: {{ salt["credentials.get_password"](container["db"]["credential"]) | yaml_dquote }}

{% for config_file in ["web.xml", "form-builder-permissions.xml"] %}
/srv/orbeon/{{ instance }}/conf/{{ config_file }}:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/orbeon/{{ instance }}/{{ config_file }}
{% endfor %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/orbeon
    - binds:
      - /srv/orbeon/{{ instance }}/conf/tomcat-users.xml:/usr/local/tomcat/conf/tomcat-users.xml
      - /srv/orbeon/{{ instance }}/conf/orbeon.xml:/usr/local/tomcat/conf/Catalina/localhost/orbeon.xml
      - /srv/orbeon/{{ instance }}/conf/web.xml:/usr/local/tomcat/webapps/orbeon/WEB-INF/web.xml
      - /srv/orbeon/{{ instance }}/conf/form-builder-permissions.xml:/usr/local/tomcat/webapps/orbeon/WEB-INF/resources/config/form-builder-permissions.xml
      - /srv/orbeon/{{ instance }}/conf/properties-local.xml:/usr/local/tomcat/webapps/orbeon/WEB-INF/resources/config/properties-local.xml
    - ports:
      - 8080
    - port_bindings:
      - 127.0.0.1:{{ container['app_port'] }}:8080
    - networks:
      - {{ container['network'] }}

{% endfor %}
