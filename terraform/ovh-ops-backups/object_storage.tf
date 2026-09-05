#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Storage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create object storage bucket for backups.
#   Provider:       OVH
#   Target:         OVH Public Cloud > Nasqueron :: Operations :: Backups
#   -------------------------------------------------------------

module "backup" {
  source   = "./modules/object_storage_container"
  for_each = local.backup_containers

  service_name   = ovh_cloud_project.nasqueron-ops-backups.id
  container_name = each.value.container_name

  tags = each.value.tags
}
