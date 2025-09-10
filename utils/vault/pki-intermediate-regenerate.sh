#!/bin/sh

set -e

export VAULT_SKIP_VERIFY=1

PKI_ROOT=pki_root
PKI_INTERMEDIATE=pki_vault
WORKDIR=$(mktemp -d -t vault-intermediate)

cd "$WORKDIR"

vault write -format=json $PKI_INTERMEDIATE/intermediate/generate/internal \
    common_name="nasqueron.drake Intermediate Authority" \
    issuer_name="drake-nasqueron-intermediate" \
    | jq -r '.data.csr' > cert_intermediate.csr

vault write -format=json $PKI_ROOT/root/sign-intermediate \
    issuer_ref="root-2022" \
    csr=@cert_intermediate.csr \
    format=pem_bundle ttl="8760h" \
    | jq -r '.data.certificate' > cert_intermediate.pem

ISSUER=$(vault write -format=json $PKI_INTERMEDIATE/intermediate/set-signed \
    certificate=@cert_intermediate.pem \
    | jq -r '.data.imported_issuers[0]')

vault write $PKI_INTERMEDIATE/roles/nasqueron-drake \
    issuer_ref="$ISSUER" \
    allowed_domains="nasqueron.drake" \
    allow_subdomains=true \
    max_ttl="2160h"

cd /tmp
rm "$WORKDIR"/cert*
rmdir "$WORKDIR"
