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
the token defined in your `$HOME/.vault-token` file. Ensure it doesn't end with a
newline. If so, you can use `tr -d '\n'` to remove it.
