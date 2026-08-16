#   -------------------------------------------------------------
#   Terraform :: OVH :: Providers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Provider:       OVH / Vault / OpenBao
#   Target:         complector.nasqueron.drake
#   -------------------------------------------------------------

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = ">= 2.19.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = ">= 5.11.0"
    }
  }
}

#   -------------------------------------------------------------
#   Providers configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

provider "ovh" {
  endpoint = "ovh-eu"
}

provider "vault" {
  address = "https://172.27.27.7:8200"
}
