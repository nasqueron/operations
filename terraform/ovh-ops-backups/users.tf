#   -------------------------------------------------------------
#   Terraform :: OVH :: S3 Users and Policies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Provider:       OVH
#   Target:         OVH Public Cloud > Nasqueron :: Operations :: Backups
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Flattened backup containers and clients into client accounts
#
#   Used to create S3 users like user-bak-<container>-<client>
#   e.g. "user-bak-amaris-windriver"
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

locals {
  backup_client_accounts = {
    for account in flatten([
      for container_key, container in local.backup_containers : [
        for client_key, client in container.clients : {
          key = "${container_key}-${client_key}"

          container_key  = container_key
          container_name = container.container_name

          client_key = client_key
          prefixes   = client.prefixes

          account_name = "user-bak-${container_key}-${client_key}"
          description  = "Service account for ${client_key} on ${container.container_name}"
        }
      ]
    ]) : account.key => account
  }
}

#   -------------------------------------------------------------
#   Create user accounts and apply prefix policies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

module "backup_client_accounts" {
  source   = "./modules/object_storage_project_user"
  for_each = local.backup_client_accounts

  service_name   = ovh_cloud_project.nasqueron-ops-backups.id
  account_name   = each.value.account_name
  description    = each.value.description
  container_name = each.value.container_name
  prefixes       = each.value.prefixes
}
