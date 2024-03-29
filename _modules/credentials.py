# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Credentials-related execution module methods
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import ipaddress
import os

from salt.utils.files import fopen


VAULT_PREFIX = "ops/secrets/"


#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def _are_credentials_hidden():
    return "CONFIG_PUBLISHER" in os.environ or "state.show_sls" in os.environ.get(
        "SUDO_COMMAND", ""
    )


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
#   Fetch credentials from Vault
#
#   Methods signatures are compatible with Zemke-Rhyne module.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def _get_default_secret_path():
    return VAULT_PREFIX


def read_secret(key, prefix=None):
    if _are_credentials_hidden():
        return "credential for " + key

    if prefix is None:
        prefix = _get_default_secret_path()

    return __salt__["vault.read_secret"](f"{prefix}/{key}")


def get_password(key, prefix=None):
    """
    A function to fetch credential on Vault

    CLI Example:

        salt docker-001 credentials.get_password nasqueron.foo.bar

    :param key: The key in ops/secrets namespace
    :param prefix: the prefix path for that key, by default "ops/secrets/"
    :return: The username
    """
    return read_secret(key, prefix)["password"]


def get_username(key, prefix=None):
    """
    A function to fetch the username associated to a credential
    through Vault

    CLI Example:

        salt docker-001 credentials.get_username nasqueron.foo.bar

    :param key: The key in ops/secrets namespace
    :param prefix: the prefix path for that key, by default "ops/secrets/"
    :return: The secret value
    """
    return read_secret(key, prefix)["username"]


def get_token(key, prefix=None):
    """
    A function to fetch credential through Vault

    CLI Example:

        salt docker-001 credentials.get_token nasqueron.foo.bar

    :param key: The key in ops/secrets namespace
    :param prefix: the prefix path for that key, by default "ops/secrets/"
    :return: The secret value

    For Vault, this is actually an alias of the get_password method.
    """
    return get_password(key, prefix)


def get_dsn(host, key, prefix=None):
    if _are_credentials_hidden():
        return "credential for " + key

    secret = read_secret(key, prefix)
    return f"{secret['username']}:{secret['password']}@{host}"


#   -------------------------------------------------------------
#   Helpers for IPv6 DUID credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_duid_credential_paths(node):
    return {
        key: _get_duid_path(interface)
        for key, interface in _get_duid_interfaces(node).items()
    }


def get_duid_credentials():
    id = __grains__["id"]

    return {
        key: _read_duid_secret(interface)
        for key, interface in _get_duid_interfaces(id).items()
    }


def _get_duid_interfaces(node):
    return {
        key: interface
        for key, interface in __pillar__["nodes"][node]["network"]["interfaces"].items()
        if _is_duid_interface(interface)
    }


def _is_duid_interface(interface):
    return (
        "ipv6" in interface
        and "flags" in interface
        and "ipv6_dhcp_duid" in interface["flags"]
    )


def _read_duid_secret(interface):
    path = _get_duid_path(interface)

    return __salt__["vault.read_secret"](path)["password"]


def _get_duid_path(interface):
    address = interface["ipv6"]["address"]
    prefixlen = interface["ipv6"]["prefix"]
    prefix = _get_prefix(address, prefixlen)

    return f"ops/secrets/network/DUID/{prefix}"


def _get_prefix(address, prefixlen):
    ip = ipaddress.IPv6Network((address, prefixlen), strict=False)
    return str(ip.network_address)


#   -------------------------------------------------------------
#   Helpers for Sentry credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_sentry_dsn(args):
    if _are_credentials_hidden():
        return "credential for " + args["credential"]

    host = __pillar__["sentry_realms"][args["realm"]]["hostname"]
    key = get_username(args["credential"])

    return f"https://{key}@{host}/{args['project_id']}"


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
            [_get_read_rule(vault_path) for vault_path in vault_paths]
        )

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


def _get_read_rule(vault_path):
    resolved_vault_path = _resolve_vault_path(vault_path)

    return f"""path \"{resolved_vault_path}\" {{
    capabilities = [ \"read\" ]
}}"""


def _resolve_vault_path(vault_path):
    for pillar_path, mount_path in __pillar__.get("vault_mount_paths", {}).items():
        if vault_path.startswith(pillar_path):
            start_position = len(pillar_path)
            return mount_path + vault_path[start_position:]

    return vault_path


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

    cluster = __salt__["node.get"]("dbserver:cluster", node)
    if cluster is not None:
        dbserver_rules_paths = __pillar__["vault_secrets_by_dbserver_cluster"].get(
            cluster, []
        )
        rules.append(
            _join_document_fragments(
                [_get_read_rule(vault_path) for vault_path in dbserver_rules_paths]
            )
        )

    for _, vault_path in get_duid_credential_paths(node).items():
        rules.append(_get_read_rule(vault_path))

    policy = _join_document_fragments(rules)

    if not policy:
        policy = "# This policy is intentionally left blank."

    policy = policy.replace("%%node%%", node)

    return policy


def build_policies_by_node():
    roles_policies = _compile_roles_policies()

    policies = {
        node: _build_node_policy(node, roles_policies)
        for node in __pillar__["nodes"].keys()
    }

    return policies
