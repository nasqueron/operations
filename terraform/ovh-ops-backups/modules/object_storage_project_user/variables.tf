#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Project user
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create user with access to object storage container
#                   for backups in specified prefix.
#   Provider:       OVH
#   -------------------------------------------------------------

variable "service_name" {
  description = "OVH Cloud Project service name."
  type        = string
}

variable "account_name" {
  description = "Logical account name, for example user-bak-amaris-windriver."
  type        = string
}

variable "description" {
  description = "Description of the OVH user."
  type        = string
}

variable "container_name" {
  description = "Object storage container (S3 bucket) name."
  type        = string
}

variable "prefixes" {
  description = "S3 key prefixes this account may access."
  type        = list(string)

  validation {
    condition     = length(var.prefixes) > 0
    error_message = "At least one S3 prefix is required."
  }
}
