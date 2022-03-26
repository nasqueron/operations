#   -------------------------------------------------------------
#   Salt — Provision OpenSearch
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set config = salt['opensearch.get_config']() %}

#   -------------------------------------------------------------
#   Security plugin
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/opt/opensearch/plugins/opensearch-security/securityconfig/internal_users.yml:
  file.managed:
    - source: salt://roles/opensearch/opensearch/files/internal_users.yml.jinja
    - user: opensearch
    - group: opensearch
    - mode: 600
    - template: jinja
    - context:
        users:
          {% for user, credential in config['users'].items() %}
          {{ user }}:
            username: {{ salt['zr.get_username'](credential) }}
            password: {{ salt['zr.get_password'](credential) }}
          {% endfor %}

opensearch_security_initialize:
   cmd.script:
     - source: salt://roles/opensearch/opensearch/files/security_initialize.sh
     - args: {{ config['network_host'] }}
     - env:
         JAVA_HOME: /opt/opensearch/jdk
     - creates: /opt/opensearch/plugins/opensearch-security/securityconfig/.initialized
