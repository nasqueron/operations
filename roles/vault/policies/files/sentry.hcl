#   -------------------------------------------------------------
#   Vault configuration - Policy for Sentry
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/vault/policies/files/sentry.hcl
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

path "apps/data/sentry/github" {
    capabilities = [ "read" ]
}

path "ops/data/secrets/nasqueron/sentry/app_key" {
    capabilities = [ "read" ]
}

path "ops/data/secrets/nasqueron/sentry/postgresql" {
    capabilities = [ "read" ]
}
