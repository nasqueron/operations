#   -------------------------------------------------------------
#   Salt — Provision OpenSearch
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set config = salt['opensearch.get_config']() %}
{% set root = "/opt/opensearch/config/index_policies" %}

{% for policy in config['index_management']['index_policies'] %}

{{ root }}/{{ policy }}.json:
  file.managed:
    - source: salt://roles/opensearch/files/index_policies/{{ policy }}.json
    - user: opensearch
    - group: opensearch
    - mode: 0644

apply_index_policy_{{ policy }}:
  cmd.run:
    - name: |
        es-query _plugins/_ism/policies/{{ policy }} -XPUT -d @{{ root }}/{{ policy }}.json
        touch {{ root }}/.policy-applied-{{ policy }}
    - creates: {{ root }}/.policy-applied-{{ policy }}

{% endfor %}
