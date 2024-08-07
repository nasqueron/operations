#   -------------------------------------------------------------
#   Vault configuration - Policy for Nasqueron Ops SIG beings
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/vault/policies/files/admin.hcl
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

#   -------------------------------------------------------------
#   Health check
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

path "sys/health" {
  capabilities = ["read", "sudo"]
}

#   -------------------------------------------------------------
#   Policies management
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

path "sys/policies/acl" {
  capabilities = ["list"]
}

path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

#   -------------------------------------------------------------
#   Authentication management
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}

path "sys/auth" {
  capabilities = ["read"]
}

#   -------------------------------------------------------------
#   Secrets management
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

path "sys/mounts" {
  capabilities = ["read"]
}

path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "apps/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "ops/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

#   -------------------------------------------------------------
#   PKI
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

path "pki_root/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

path "pki_vault/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

#   -------------------------------------------------------------
#   Transit
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

path "transit/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "transit/keys/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
