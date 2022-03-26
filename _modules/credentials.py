# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Credentials-related execution module methods
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


from salt.utils.files import fopen


#   -------------------------------------------------------------
#   HOF utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def _filter_discard_empty_string_values(haystack):
    if type(haystack) is dict:
        return {k: v for k, v in haystack.items() if v != ""}

    if type(haystack) is list:
        return [v for v in haystack if v != ""]

    raise ValueError("Argument isn't a list or a dict: " + str(type(haystack)))


def _join_document_fragments(fragments):
    filtered = _filter_discard_empty_string_values(fragments)
    return "\n\n".join(filtered)


#   -------------------------------------------------------------
#   Build Vault policies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


class VaultSaltRolePolicy:
    def __init__(self, role):
        self.role = role

    def build_policy(self):
        return _join_document_fragments(
            [
                self.build_read_secrets_policy(),
                self.import_extra_policies(),
            ]
        )

    #
    # Secrets from pillar entry vault_secrets_by_role
    #

    def build_read_secrets_policy(self):
        vault_paths = __pillar__["vault_secrets_by_role"].get(self.role, [])

        return _join_document_fragments(
            [self.get_read_rule(vault_path) for vault_path in vault_paths]
        )

    def get_read_rule(self, vault_path):
        resolved_vault_path = self.resolve_vault_path(vault_path)

        return f"""path \"{resolved_vault_path}\" {{
    capabilities = [ \"read\" ]
}}"""

    @staticmethod
    def resolve_vault_path(vault_path):
        for pillar_path, mount_path in __pillar__.get("vault_mount_paths", {}).items():
            if vault_path.startswith(pillar_path):
                start_position = len(pillar_path)
                return mount_path + vault_path[start_position:]

        return vault_path

    #
    # Import policies from pillar entry vault_extra_policies_by_role
    #

    def import_extra_policies(self):
        extra_policies = __pillar__["vault_extra_policies_by_role"].get(self.role, [])
        return _join_document_fragments(
            [self.import_policy(policy) for policy in extra_policies]
        )

    @staticmethod
    def import_policy(policy):
        policy_file = f"{__pillar__['vault_policies_source']}/{policy}.hcl"

        if policy_file.startswith("salt://"):
            policy_file = __salt__["cp.cache_file"](policy_file)

        with fopen(policy_file) as fd:
            return fd.read()


def _compile_roles_policies():
    return {
        role: VaultSaltRolePolicy(role).build_policy() for role in _get_relevant_roles()
    }


def _get_relevant_roles():
    return {
        role
        for pillar_entry in [
            "vault_extra_policies_by_role",
            "vault_secrets_by_role",
        ]
        for role in __pillar__[pillar_entry].keys()
    }


def _build_node_policy(node, roles_policies):
    rules = [
        roles_policies[role]
        for role in __salt__["node.get"]("roles", node)
        if role in roles_policies
    ]
    return _join_document_fragments(rules)


def build_policies_by_node():
    roles_policies = _compile_roles_policies()

    policies = {
        node: _build_node_policy(node, roles_policies)
        for node in __pillar__["nodes"].keys()
    }

    return _filter_discard_empty_string_values(policies)
