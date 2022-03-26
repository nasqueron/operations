#   -------------------------------------------------------------
#   Salt — Provision OpenSearch
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   -------------------------------------------------------------

{% set config = salt['opensearch.get_config']() %}

#   -------------------------------------------------------------
#   OpenSearch
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/opt/opensearch/config/opensearch.yml:
  file.managed:
    - source: salt://roles/opensearch/opensearch/files/opensearch.conf
    - user: opensearch
    - group: opensearch
    - template: jinja
    - context:
        config: {{ config }}

/opt/opensearch/config/jvm.options:
  file.managed:
    - source: salt://roles/opensearch/opensearch/files/jvm.options
    - user: opensearch
    - group: opensearch
    - template: jinja
    - context:
        heap_size: {{ config['heap_size'] }}

#   -------------------------------------------------------------
#   TLS certificates
#
#   This method is based on OpenSearch Ansible playbook to
#   generate self-signed certificates for node to node (transport)
#   communication, and for the rest API.
#
#   The certificates are generated by Search Guard Offline TLS Tool.
#
#   This should only run on one node, then provisioned everywhere.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/dl/search-guard-tlstool.zip:
  file.managed:
    - source: https://maven.search-guard.com/search-guard-tlstool/1.8/search-guard-tlstool-1.8.zip
    - source_hash: f59f963c7ee28d557849ccde297660a3c593a6bf3531d7852fb9ab8b4fc7597e

/opt/tlstool:
  file.directory:
     - mode: 700
  archive.extracted:
    - source: /usr/local/dl/search-guard-tlstool.zip
    - enforce_toplevel: False

/opt/tlstool/config/tlsconfig.yml:
  file.managed:
    - source: salt://roles/opensearch/opensearch/files/tlsconfig.yml.jinja
    - template: jinja
    - context:
        config: {{ config }}
        domain_name: {{ grains['domain'] }}
        node_full_domain_name: {{ grains['fqdn'] }}

opensearch_generate_certificates:
  cmd.run:
     - name: /opt/tlstool/tools/sgtlstool.sh -c /opt/tlstool/config/tlsconfig.yml -ca -crt -t /opt/tlstool/config/
     - env:
         JAVA_HOME: /opt/opensearch/jdk
     - creates: /opt/tlstool/config/root-ca.pem

{% for certificate in salt['opensearch.list_certificates']() %}

opensearch_deploy_certificate_{{ certificate }}:
   cmd.run:
     - name: install --mode=0600 --owner=opensearch {{ certificate }}.pem {{ certificate }}.key /opt/opensearch/config
     - cwd: /opt/tlstool/config
     - creates: /opt/opensearch/config/{{ certificate }}.pem

{% endfor %}
