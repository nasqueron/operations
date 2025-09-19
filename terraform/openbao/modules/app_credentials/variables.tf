#   -------------------------------------------------------------
#   Terraform :: OpenBao :: Modules :: App Credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

variable "role_name" {
    description = "Name of the AppRole"
    type = string
}

variable "kv_mount" {
    description = "Mount path of KV v2 engine where to save the approle credentials"
    type = string
    default = "kv"
}

variable "kv_path" {
    description = "KV v2 secret path where to save the approle credentials"
    type = string
}

variable "policies" {
    description = "List of policies attached to this AppRole"
    type = list(string)
}

variable "secret_id_bound_cidrs" {
    description = "List of CIDR blocks of IP addresses allowed to login."
    type = list(string)
    default = []
}

variable "token_ttl" {
    description = "Default token TTL for the AppRole"
    type = string
    default = "300"
}
