#!/bin/sh

#   -------------------------------------------------------------
#   Unseal Vault on Eglide from secret store in main Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

set -e

KEY=ops/secrets/eglide/vault/unseal
SERVER=eglide.org

#   -------------------------------------------------------------
#   Unseal
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

for i in 1 3 5; do
    vault kv get -format=json $KEY | jq -r .data.data.key$i | ssh $SERVER "socat STDIO 'EXEC:vault operator unseal,PTY'"
done
