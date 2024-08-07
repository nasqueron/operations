#!/usr/bin/env bash
#   -------------------------------------------------------------
#   Vault initialize script
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Description:    Recreate the engines and configure them.
#
#                   Should be run only once for the cluster
#                   for disaster recovery purpose if the storage
#                   back-end can't be restored.
#
#                   Will issue a new root CA certificate.
#
#   Dependencies:   bash is used as shebang to allow >() process
#                   execution, undefined in POSIX sh.
#   To sync with:   roles/vault/policies/files/vault_bootstrap.hcl
#   Source file:    roles/vault/vault/files/vault-initialize.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

set -e

PREFIX_PKI=pki_
DOMAIN=nasqueron.drake
CERTS_PATH=/usr/local/share/certs
PUBLIC_URL=https://api.nasqueron.org/infra/security/pki

VAULT_CERTS_PATH=/usr/local/etc/certificates/vault

#   -------------------------------------------------------------
#   Authentication :: token roles
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vault write auth/token/roles/salt-node allowed_policies_glob="salt-node-*" token_bound_cidrs="127.0.0.1,172.27.27.0/24"
vault write auth/token/roles/admin allowed_policies=admin period=30d

#   -------------------------------------------------------------
#   PKI :: root CA
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CA_ROOT_NAME=root
CA_ROOT_PATH=$PREFIX_PKI$CA_ROOT_NAME

vault secrets enable -path=$CA_ROOT_PATH pki
vault secrets tune -max-lease-ttl=87600h

vault write -field=certificate $CA_ROOT_PATH/root/generate/internal \
  common_name=$DOMAIN \
  ttl=87600h > $CERTS_PATH/nasqueron-vault-ca.crt

vault write $CA_ROOT_PATH/config/urls \
  issuing_certificates="$PUBLIC_URL/$CA_ROOT_NAME/ca" \
  crl_distribution_points="$PUBLIC_URL/$CA_ROOT_NAME/crl"


#   -------------------------------------------------------------
#   PKI :: intermediate CA for Vault own certificates
#
#   Intermediate certificate is signed by the root CA one.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CA_VAULT_NAME=vault
CA_VAULT_PATH=$PREFIX_PKI$CA_VAULT_NAME

vault secrets enable -path=$CA_VAULT_PATH pki
vault secrets tune -max-lease-ttl=2160h "$CA_VAULT"

CSR=$(mktemp /tmp/csr.XXXX)
vault write -format=json $CA_VAULT_PATH/intermediate/generate/internal \
  common_name="$DOMAIN Intermediate Authority" \
  | jq -r '.data.csr' > "$CSR"
vault write -format=json $CA_ROOT_PATH/root/sign-intermediate csr=@"$CSR" \
  format=pem_bundle ttl="2160h" \
  | jq -r '.data.certificate' > $CERTS_PATH/nasqueron-vault-intermediate.crt
rm "$CSR"

vault write $CA_VAULT_PATH/intermediate/set-signed \
  certificate=@$CERTS_PATH/nasqueron-vault-intermediate.crt

vault write $CA_VAULT_PATH/config/urls \
  issuing_certificates="$PUBLIC_URL/$CA_VAULT_NAME/ca" \
  crl_distribution_points="$PUBLIC_URL/$CA_VAULT_NAME/crl"

vault write $CA_VAULT_PATH/roles/nasqueron-drake \
  allowed_domains="nasqueron.drake" \
  allow_subdomains=true \
  max_ttl="2160h"

#   -------------------------------------------------------------
#   Vault configuration artifacts
#
#   :: TLS certificate generated by intermediate PKI
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mkdir -p $VAULT_CERTS_PATH

vault write -format=json $CA_VAULT_PATH/issue/nasqueron-drake \
  common_name="complector.nasqueron.drake" ttl="2160h" \
  ip_sans="127.0.0.1,172.27.27.7" | tee \
  >(jq -r .data.certificate > $VAULT_CERTS_PATH/certificate.pem) \
  >(jq -r .data.issuing_ca > $VAULT_CERTS_PATH/ca.pem) \
  >(jq -r .data.private_key > $VAULT_CERTS_PATH/private.key)

cat $VAULT_CERTS_PATH/certificate.pem $VAULT_CERTS_PATH/ca.pem > $VAULT_CERTS_PATH/fullchain.pem
