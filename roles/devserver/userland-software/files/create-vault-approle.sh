#!/bin/sh

VAULT_POLICY=$1

vault write "auth/approle/role/$VAULT_POLICY" token_policies="$VAULT_POLICY" \
    token_ttl=1h token_max_ttl=4h

vault read "auth/approle/role/$VAULT_POLICY/role-id"
vault write -force "auth/approle/role/$VAULT_POLICY/secret-id"
