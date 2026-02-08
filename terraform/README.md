# Terraform configurations

## Providers

### OpenBao / Vault

Use this provider to interact with Vault.

The following modules are available:

   - **app_credentials:** create new AppRole credentials, save them in kv

Policies can be found in the `policies/` directory.
They supplement the policies defined in roles/vault/policies/ with Salt.

When you read a policy through `vault policy read`, look at the `Source file:` field
in headers block. That will tell you the exact path where the policy is defined.

To run this provider, Terraform will automatically authenticate to Vault using
the token defined in your `$HOME/.vault-token` file.

#### AppRole credentials

Run the provider through `make rotate` so you can regenerate, rotate and deploy
all the secrets.

If you add a new AppRole, remember to also add the Salt instructions in
`openbao/Makefile`.
