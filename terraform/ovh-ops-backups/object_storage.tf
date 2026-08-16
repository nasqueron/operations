#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Storage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create object storage bucket for backups.
#   Provider:       OVH
#   Target:         OVH Public Cloud > Nasqueron :: Operations :: Backups
#   -------------------------------------------------------------

resource "ovh_cloud_project_storage" "storage_backups" {
  service_name = ovh_cloud_project.nasqueron-ops-backups.id
  name         = var.bucket
  region_name = "EU-WEST-PAR"

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

  tags = {
    group = "operations"
    role = "backup"
    encryption = "client-side"
    privacy_level = "sensible"
  }

  lifecycle {
    prevent_destroy = true
  }
}
