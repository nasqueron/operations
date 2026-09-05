#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Storage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create object storage container for backups.
#   Provider:       OVH
#   -------------------------------------------------------------

resource "ovh_cloud_project_storage" "container" {
  service_name = var.service_name
  name         = var.container_name
  region_name  = var.region_name

  # S3 Object Lock requires versioning to be enabled.
  versioning = {
    status = "enabled"
  }

  object_lock = {
    status = "enabled"
    rule = {
      # Governance mode protects against malicious deletion.
      # To prune old backups, a separate admin credential with
      # s3:BypassGovernanceRetention permission must be used.
      mode   = "governance"
      period = "P90D" # 90 days default retention
    }
  }

  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}
