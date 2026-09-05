#   -------------------------------------------------------------
#   Terraform :: OVH :: Variables
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Provider:       OVH / Vault
#   -------------------------------------------------------------

variable "bucket" {
  description = "The name of the bucket."
  type        = string
  default     = "nasqueron-backups-amaris"
}
