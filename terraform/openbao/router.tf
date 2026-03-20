#   -------------------------------------------------------------
#   Terraform :: OpenBao :: Router
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Provider:       Vault / OpenBao
#   Target:         completor.nasqueron.drake
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Policy
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "vault_policy" "router" {
    name = "router"
    policy = file("${path.module}/policies/router.hcl")
}

#   -------------------------------------------------------------
#   AppRole
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

module "router_approle" {
    source = "./modules/app_credentials"

    role_name = "router"
    policies = ["router"]

    secret_id_bound_cidrs = [
        "172.27.27.11/32", # router-002
        "172.27.27.12/32", # router-003
    ]

    # Save credentials to
    kv_mount = "ops"
    kv_path = "secrets/network/router/vault"
}
