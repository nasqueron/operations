#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Storage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create object storage bucket for backups.
#   Provider:       OVH
#   -------------------------------------------------------------

terraform {
  required_version = ">= 0.13"

  required_providers {
    ovh = {
      source = "ovh/ovh"

      # For object lock support
      version = ">= 2.11.0"
    }
  }
}
