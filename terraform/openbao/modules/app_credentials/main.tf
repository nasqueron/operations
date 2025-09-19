#   -------------------------------------------------------------
#   Terraform :: OpenBao :: Modules :: App Credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Module to create an AppRole and store its
#                   credentials in KV v2.
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Create AppRole, fetch role_id and secret_id
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "vault_approle_auth_backend_role" "this" {
    backend = "approle"

    role_name = var.role_name
    secret_id_bound_cidrs = var.secret_id_bound_cidrs
    token_policies = var.policies
    token_ttl = var.token_ttl
}

data "vault_approle_auth_backend_role_id" "this" {
    backend = "approle"
    role_name = vault_approle_auth_backend_role.this.role_name
}

resource "vault_approle_auth_backend_role_secret_id" "this" {
    backend = "approle"
    role_name = vault_approle_auth_backend_role.this.role_name

    lifecycle {
        ignore_changes = [
            secret_id,
        ]
    }
}

#   -------------------------------------------------------------
#   Store AppRole credentials in KV v2
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "vault_kv_secret_v2" "this" {
    mount = var.kv_mount
    name = var.kv_path

    data_json = jsonencode({
        role_id = data.vault_approle_auth_backend_role_id.this.role_id
        secret_id = vault_approle_auth_backend_role_secret_id.this.secret_id
    })
}
