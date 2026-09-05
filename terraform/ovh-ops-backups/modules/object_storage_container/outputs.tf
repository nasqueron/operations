#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Storage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create object storage bucket for backups.
#   Provider:       OVH
#   -------------------------------------------------------------

output "container" {
  description = "Object container created"
  value = {
    name = ovh_cloud_project_storage.container.name
    id   = ovh_cloud_project_storage.container.id
  }
}
