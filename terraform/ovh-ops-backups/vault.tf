#   -------------------------------------------------------------
#   Terraform :: OVH :: Store S3 Credentials in OpenBao/Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Provider:       OVH / Vault / OpenBao
#   Target:         complector.nasqueron.drake
#   -------------------------------------------------------------

locals {
  s3_endpoint = "https://s3.eu-west-par.io.cloud.ovh.net"
}

resource "vault_kv_secret_v2" "ovh_s3_credentials" {
  for_each = local.backup_client_accounts

  mount = "ops"
  name  = "secrets/backups/ovh/s3/${each.key}"

  data_json = jsonencode({
    access_key = module.backup_client_accounts[each.key].s3_credentials.access_key
    secret_key = module.backup_client_accounts[each.key].s3_credentials.secret_key
  })

  custom_metadata {
    data = {
      container_name = each.value.container_name
      endpoint       = "s3:${local.s3_endpoint}/${each.value.container_name}/"
      prefixes       = join(", ", each.value.prefixes)
    }
  }

  # We use lifecycle to prevent Terraform from trying to update the secret
  # if it is manually rotated or changed in Vault after initial creation.
  # Note: The generated secret_access_key from OVH will still be present in
  # the Terraform state file of the `ovh_cloud_project_user_s3_credential`
  # resource, as Terraform must store managed resource attributes in state.
  # Ensure your Terraform state backend is strictly encrypted and access-controlled.
  lifecycle {
    ignore_changes = [
      data_json,
    ]
  }
}
