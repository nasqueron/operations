#   -------------------------------------------------------------
#   Terraform :: OpenBao :: Providers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

terraform {
    required_providers {
        vault = {
            source = "hashicorp/vault"
            version = "5.3.0"
        }
    }
}

provider "vault" {
    token = file("~/.vault-token")
}
