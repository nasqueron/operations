#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Storage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create object storage bucket for backups.
#   Provider:       OVH
#   -------------------------------------------------------------

variable "service_name" {
  description = "The OVH Cloud Project ID / Service Name."
  type        = string
}

variable "container_name" {
  description = "The name of the object container."
  type        = string
}

variable "region_name" {
  description = "The OVH region where the bucket will be created."
  type        = string
  default     = "EU-WEST-PAR"
}

variable "tags" {
  description = "A map of tags to assign to the bucket."
  type        = map(string)
}
