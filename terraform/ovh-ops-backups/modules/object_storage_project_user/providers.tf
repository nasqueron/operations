#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Project user
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create user with access to object storage container
#                   for backups in specified prefix.
#   Provider:       OVH
#   -------------------------------------------------------------

terraform {
  // Per `for` expression
  required_version = ">= 0.12.0"

  required_providers {
    ovh = {
      source = "ovh/ovh"

      # S3
      version = ">= 0.35.0"
    }
  }
}
