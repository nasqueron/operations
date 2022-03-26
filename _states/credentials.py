# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Credentials state
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Allow to declare credentials-related states
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


from salt.utils.files import fopen


def vault_policy_present(name, policy_file):
    """
    Ensure a Vault policy with the given name is present.

    name
        The name of the policy
    policy_file
        Path to a file on the minion containing rules,
        formatted in HCL.

    .. code-block:: yaml

         demo_policy:
          vault.policy_present:
            - name: foo/bar
            - policy_file: /opt/vault-policies/demo.hcl

    """
    with fopen(policy_file) as fd:
        rules = fd.read()

    return __states__["vault.policy_present"](name, rules)
