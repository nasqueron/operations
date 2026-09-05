#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Storage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create object storage bucket for backups.
#   Provider:       OVH
#   Target:         OVH Public Cloud > Nasqueron :: Operations :: Backups
#   -------------------------------------------------------------

locals {
  default_tags = {
    group         = "operations"
    role          = "backup"
    encryption    = "client-side"
    privacy_level = "sensible"
  }

  backup_containers = {
    amaris = {
      container_name = "nasqueron-backups-amaris"
      purpose        = "Main backup container"

      tags = local.default_tags
    }

    darak = {
      container_name = "nasqueron-backups-darak"
      purpose        = "Dereckson backups"

      tags = merge(local.default_tags, {
        group = "user-dereckson"
      })
    }

    vakor = {
      container_name = "nasqueron-backups-vakor"
      purpose        = "Vault backups"

      tags = local.default_tags
    }
  }
}

module "backup" {
  source   = "./modules/object_storage_container"
  for_each = local.backup_containers

  service_name   = ovh_cloud_project.nasqueron-ops-backups.id
  container_name = each.value.container_name

  tags = each.value.tags
}
