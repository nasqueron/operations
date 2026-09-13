#!/bin/sh

#   -------------------------------------------------------------
#   Renew Vault intermediate CA :: pki_vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

set -e

PKI_ROOT=pki_root
PKI_INTERMEDIATE=pki_vault
ROLE=nasqueron-drake
VAULT=vault

#   -------------------------------------------------------------
#   Issuers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Root CA issuer (from DRP bootstrap script: root-<YEAR>, but not yet active)
ROOT_ISSUER=default

# Intermediate CA issuer
ROLE_JSON=$($VAULT read -tls-skip-verify -format=json $PKI_INTERMEDIATE/roles/$ROLE)
CURRENT_ISSUER=$(echo "$ROLE_JSON" | jq -r .data.issuer_ref)
NEW_ISSUER="drake-nasqueron-intermediate-$(date +%Y%m%d)"

#   -------------------------------------------------------------
#   Reissue the intermediate certificate
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

$VAULT pki reissue -tls-skip-verify \
    -issuer_name="$NEW_ISSUER" \
    "/$PKI_ROOT/issuer/$ROOT_ISSUER" \
    "/$PKI_INTERMEDIATE/issuer/$CURRENT_ISSUER" \
    "/$PKI_INTERMEDIATE/" \
    common_name="nasqueron.drake Intermediate Authority" \
    organization="Nasqueron" \
    ou="Nasqueron Operations SIG" \
    country="BE" \
    ttl="8760h"

#   -------------------------------------------------------------
#   Update role with new issuer
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

role_file=$(mktemp /tmp/role.old.XXXX)
updated_role_file=$(mktemp /tmp/role.new.XXXX)
trap 'rm -f "$role_file" "$updated_role_file"' EXIT

$VAULT read -tls-skip-verify -format=json $PKI_INTERMEDIATE/roles/$ROLE > "$role_file"
jq --arg issuer "$NEW_ISSUER" '.data.issuer_ref = $issuer | .data' "$role_file" > "$updated_role_file"
$VAULT write -tls-skip-verify $PKI_INTERMEDIATE/roles/$ROLE @"$updated_role_file"

echo "✅ Intermediate CA renewed and role '$ROLE' updated to use '$NEW_ISSUER'."
