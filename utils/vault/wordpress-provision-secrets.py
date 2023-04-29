#!/usr/bin/env python3

#   -------------------------------------------------------------
#   SaaS :: WordPress :: Provision Vault secrets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Write to Vault the secrets required by
#                   WordPress to the specific secret path.
#   Dependencies:   hvac
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import os
import secrets
import string
import sys

import hvac


#   -------------------------------------------------------------
#   WordPress secrets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


KEYS = [
    "AUTH_KEY",
    "SECURE_AUTH_KEY",
    "LOGGED_IN_KEY",
    "NONCE_KEY",
    "AUTH_SALT",
    "SECURE_AUTH_SALT",
    "LOGGED_IN_SALT",
    "NONCE_SALT",
]

SPECIAL_CHARS = ">!@#$%^&*()_+|~-=`{}[]:;<>,.?/"
SECRET_CHARS = string.ascii_letters + string.digits + SPECIAL_CHARS


def generate_secret(length=64, min_digits=3, min_special_chars=3):
    while True:
        secret = "".join(secrets.choice(SECRET_CHARS) for _ in range(length))
        if (
            any(c.islower() for c in secret)
            and any(c.isupper() for c in secret)
            and sum(c.isdigit() for c in secret) >= min_digits
            and sum(c in SPECIAL_CHARS for c in secret) >= min_special_chars
        ):
            break

    return secret


def generate_wordpress_secrets():
    return {key: generate_secret() for key in KEYS}


#   -------------------------------------------------------------
#   Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


VAULT_CA_CERTIFICATE = "roles/core/certificates/files/nasqueron-vault-ca.crt"


def publish_secret(secret_path, url, token, mount_point="ops", path_prefix="secrets/"):
    wordpress_secrets = generate_wordpress_secrets()

    client = hvac.Client(url=url, token=token, verify=VAULT_CA_CERTIFICATE)
    client.secrets.kv.v2.create_or_update_secret(
        mount_point=mount_point,
        path=path_prefix + secret_path,
        secret=wordpress_secrets,
    )


def read_vault_token():
    if "VAULT_TOKEN" in os.environ:
        return True, os.environ["VAULT_TOKEN"]

    if "HOME" in os.environ:
        token_path = os.path.join(os.environ["HOME"], ".vault-token")
        if os.path.isfile(token_path):
            with open(token_path) as f:
                return True, f.read().strip()

    return False, None


#   -------------------------------------------------------------
#   Application entry-point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


if __name__ == "__main__":
    argc = len(sys.argv)

    if argc < 2:
        print(f"Usage: {sys.argv[0]} <secret path>", file=sys.stderr)
        sys.exit(1)

    if "VAULT_ADDR" not in os.environ:
        print(
            "Set VAULT_ADDR environment variable to point to your current Vault installation.",
            file=sys.stderr,
        )
        print(
            "For example, `export VAULT_ADDR=https://172.27.27.7:8200`", file=sys.stderr
        )
        sys.exit(2)

    success, token = read_vault_token()
    if not success:
        print(
            "Set VAULT_TOKEN environment variable to your Vault token to authenticate the request.",
            file=sys.stderr,
        )
        print(
            "Alternatively, you can also store your token in ~/.vault-token.",
            file=sys.stderr,
        )
        sys.exit(2)

    publish_secret(sys.argv[1], os.environ["VAULT_ADDR"], token)
