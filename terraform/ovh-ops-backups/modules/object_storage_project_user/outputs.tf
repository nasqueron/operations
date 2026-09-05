#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Project user
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create user with access to object storage container
#                   for backups in specified prefix.
#   Provider:       OVH
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Variables to describe the user in other systems (e.g. Vault)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

output "account_name" {
  description = "Logical account name."
  value       = var.account_name
}

output "container_name" {
  description = "S3 container name."
  value       = var.container_name
}

output "prefixes" {
  description = "Allowed S3 prefixes."
  value       = local.normalized_prefixes
}

#   -------------------------------------------------------------
#   Variables for the module resources
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

output "user" {
  description = "OVH user"
  value = {
    id           = ovh_cloud_project_user.user.id
    openstack_rc = ovh_cloud_project_user.user.openstack_rc
    username     = ovh_cloud_project_user.user.username
  }
}

output "user_password" {
  description = "OVH user password"
  sensitive   = true
  value       = ovh_cloud_project_user.user.password
}

output "s3_credentials" {
  description = "S3 credentials"
  sensitive   = true
  value = {
    access_key = ovh_cloud_project_user_s3_credential.s3_credentials.access_key_id
    secret_key = ovh_cloud_project_user_s3_credential.s3_credentials.secret_access_key
  }
}
