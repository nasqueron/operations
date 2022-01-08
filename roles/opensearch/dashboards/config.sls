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
    - source: salt://roles/opensearch/dashboards/files/opensearch_dashboards.yml
    - user: opensearch
    - group: opensearch
    - mode: 0600
    - template: jinja
    - context:
        config: {{ config }}
        username: {{ salt['zr.get_username'](config['users']['dashboards']) }}
        password: {{ salt['zr.get_password'](config['users']['dashboards']) }}
