#   -------------------------------------------------------------
#   Terraform :: OpenBao :: Providers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.3.0"
    }
  }

  backend "local" {
    path = "/opt/terraform/encrypted/tf-states/openbao/terraform.tfstate"
  }
}

provider "vault" {
  address = "https://172.27.27.7:8200"
}
