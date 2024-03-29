#   -------------------------------------------------------------
#   Salt — Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set policies_path = pillar['vault_policies_path'] %}

#   -------------------------------------------------------------
#   Policies storage folder
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ policies_path }}:
  file.directory:
    - makedirs: True

#   -------------------------------------------------------------
#   Policies from vault_policies pillar entry
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for policy in pillar['vault_policies'] %}
{% set policy_path = policies_path + "/" + policy + ".hcl" %}

{{ policy_path }}:
  file.managed:
    - source: salt://roles/vault/policies/files/{{ policy }}.hcl
    - template: jinja

vault_policy_{{ policy }}:
  credentials.vault_policy_present:
    - name: {{ policy }}
    - policy_file: {{ policy_path }}
    - onchanges:
        - file: {{ policy_path }}

{% endfor %}

#   -------------------------------------------------------------
#   Policies per nodes intended to be used through Salt
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for node, rules in salt['credentials.build_policies_by_node']().items() %}
salt-node-{{ node }}:
  vault.policy_present:
    - rules: |
        #
        # <auto-generated>
        #   This policy is managed by our rOPS SaltStack repository.
        # </auto-generated>
        #
        {{ rules | indent(8) }}
{% endfor %}
