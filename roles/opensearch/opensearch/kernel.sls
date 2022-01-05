#   -------------------------------------------------------------
#   Salt — Provision OpenSearch
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Virtual memory
#
#   https://opensearch.org/docs/latest/opensearch/install/important-settings/
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['kernel'] == 'Linux' %}

vm.max_map_count:
  sysctl.present:
    - value: 262144

{% endif %}
