#   -------------------------------------------------------------
#   Salt — Provision OpenSearch
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import shells with context %}

#   -------------------------------------------------------------
#   User account
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

opensearch_group:
  group.present:
    - name: opensearch
    - gid: 835

opensearch_user:
  user.present:
    - name: opensearch
    - fullname: OpenSearch
    - uid: 835
    - gid: opensearch
    - home: /opt/opensearch
    - shell: {{ shells['bash'] }}

#   -------------------------------------------------------------
#   Download and extract tarballs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/dl:
  file.directory

{% if grains['kernel'] == 'Linux' and grains['cpuarch'] == 'x86_64' %}
{% for product, info in pillar['opensearch_products'].items() %}

{% set distname = product + "-" + info['version'] %}

/usr/local/dl/{{ distname }}.tar.gz:
  file.managed:
    - source: https://artifacts.opensearch.org/releases/bundle/{{ product }}/{{ info['version'] }}/{{ distname }}-linux-x64.tar.gz
    - source_hash: {{ info['hash'] }}

/opt/{{ product }}:
  file.directory:
    - user: opensearch
    - group: opensearch

extract_opensearch_{{ product }}:
  archive.extracted:
    - name: /opt/{{ product }}
    - source: /usr/local/dl/{{ distname }}.tar.gz
    - user: opensearch
    - group: opensearch
    - enforce_toplevel: False
    - options: --strip 1

{% endfor %}
{% endif %}

/opt/opensearch/plugins/opensearch-security/tools/hash.sh:
  file.managed:
    - mode: 755

#   -------------------------------------------------------------
#   Cleanup legacy versions
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for product, versions in pillar['opensearch_legacy_products'].items() %}
{% for version in versions %}

/usr/local/dl/{{ product }}-{{ version }}.tar.gz:
  file.absent

{% endfor %}
{% endfor %}
