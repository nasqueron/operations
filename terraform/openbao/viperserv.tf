#   -------------------------------------------------------------
#   Terraform :: OpenBao :: ViperServ
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Provider:       Vault / OpenBao
#   Target:         completor.nasqueron.drake
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Policy
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "vault_policy" "viperserv" {
    name = "viperserv"
    policy = file("${path.module}/policies/viperserv.hcl")
}

#   -------------------------------------------------------------
#   AppRole
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

module "viperserv_approle" {
    source = "./modules/app_credentials"

    role_name = "viperserv"
    policies = ["viperserv"]

    secret_id_bound_cidrs = [
        # Windriver
        "172.27.27.35/32"
    ]

    token_ttl = 3600        # 1h
    token_max_ttl = 14400   # 4h

    # Save credentials to
    kv_mount = "ops"
    kv_path = "secrets/nasqueron/viperserv/vault"
}
