#   -------------------------------------------------------------
#   Salt — Provision OpenSearch
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   -------------------------------------------------------------

{% set config = salt['opensearch.get_config']() %}

#   -------------------------------------------------------------
#   OpenSearch
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/opt/opensearch-dashboards/config/opensearch_dashboards.yml:
  file.managed:
    - source: salt://roles/opensearch/dashboards/files/opensearch_dashboards.yml.jinja
    - user: opensearch
    - group: opensearch
    - mode: 600
    - template: jinja
    - show_changes: False
    - context:
        config: {{ config }}
        username: {{ salt['credentials.get_username'](config['users']['dashboards']) }}
        password: {{ salt['credentials.get_password'](config['users']['dashboards']) }}
