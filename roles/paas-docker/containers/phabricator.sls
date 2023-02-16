#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-06
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['phabricator'].items() %}
{% set create_container = "skip_container" not in container or not container['skip_container'] %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/phabricator/{{ instance }}:
  file.directory:
    - user: 431
    - group: 433
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}_data:
  selinux.fcontext_policy_present:
    - name: /srv/phabricator/{{  instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/phabricator/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Container
#
#   /!\ DEVCENTRAL DEPLOYMENT ISSUE /!\
#
#   We've currently a chicken or egg problem here: the zr
#   credentials source is the Nasqueron Phabricator instance,
#   DevCentral. As such, we can't provision it through this block.
#
#   This is blocked by secrets migration to Vault.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if create_container %}

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/phabricator
    - binds:
        - /srv/phabricator/{{ instance }}/conf:/opt/phabricator/conf
        - /srv/phabricator/{{ instance }}/repo:/var/repo
    - environment:
        PHABRICATOR_URL: https://{{ container['host'] }}
        PHABRICATOR_TITLE: {{ container['title'] }}
        PHABRICATOR_DOMAIN: {{ container['host'] }}
        PHABRICATOR_ALT_FILE_DOMAIN: https://{{ container['static_host'] }}

        DB_USER: {{ salt['credentials.get_username'](container['credentials']['mysql']) }}
        DB_PASS: {{ salt['credentials.get_password'](container['credentials']['mysql']) }}
        PHABRICATOR_STORAGE_NAMESPACE: {{ container['storage']['namespace'] }}

        {% if container['mailer'] == 'sendgrid' %}
        PHABRICATOR_USE_SENDGRID: 1
        PHABRICATOR_SENDGRID_APIUSER: {{ salt['credentials.get_username'](container['credentials']['sendgrid']) }}
        PHABRICATOR_SENDGRID_APIKEY: {{ salt['credentials.get_password'](container['credentials']['sendgrid']) }}
        {% elif container['mailer'] == 'mailgun' %}
        PHABRICATOR_USE_MAILGUN: 1
        PHABRICATOR_MAILGUN_APIKEY: {{ salt['credentials.get_token'](container['credentials']['mailgun']) }}
        {% endif %}

    - links: {{ container['mysql_link'] }}:mysql
    - ports:
        - 80
    - port_bindings:
        - {{ container['app_port'] }}:80

{% endif %}

{% endfor %}
