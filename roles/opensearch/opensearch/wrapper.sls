#   -------------------------------------------------------------
#   Salt — Provision OpenSearch
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set config = salt['opensearch.get_config']() %}

#   -------------------------------------------------------------
#   Wrapper for curl
#   Admin client for OpenSearch
#
#   https://opensearch.org/docs/latest/opensearch/install/important-settings/
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/bin/es-query:
  file.managed:
    - source: salt://roles/opensearch/opensearch/files/es-query.sh.jinja
    - mode: 0755
    - template: jinja
    - context:
        url: https://{{ config['network_host'] }}:9200

/root/.opensearch-account:
  file.managed:
     - source: salt://roles/opensearch/opensearch/files/account.conf
     - mode: 0600
     - template: jinja
     - context:
        username: {{ salt['zr.get_username'](config['users']['admin']) }}
        password: {{ salt['zr.get_password'](config['users']['admin']) }}
