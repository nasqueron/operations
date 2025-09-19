#   -------------------------------------------------------------
#   Terraform :: OpenBao :: Rhyne-Wyse
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Provider:       Vault / OpenBao
#   Target:         completor.nasqueron.drake
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Policy
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "vault_policy" "rhyne_wyse" {
    name = "rhyne-wyse"
    policy = file("${path.module}/policies/rhyne-wyse.hcl")
}

#   -------------------------------------------------------------
#   AppRole
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

module "rhyne_wyse_approle" {
    source = "./modules/app_credentials"

    role_name = "rhyne-wyse"
    policies = ["rhyne-wyse"]

    secret_id_bound_cidrs = [
        # Windriver
        "172.27.27.35/32"
    ]

    # Save credentials to
    kv_mount = "ops"
    kv_path = "secrets/nasqueron/rhyne-wyse/vault"
}
