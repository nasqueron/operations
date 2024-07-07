#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Salt :: Issue admin token
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Issue admin token, with or without certificate check
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import hvac
import yaml
import sys


VAULT_TLS_CERTIFICATE_PATH = "/usr/local/share/certs/nasqueron-root-ca.crt"


def get_config_path():
    # As long as we deploy primary servers on FreeBSD,
    # this path is stable.
    return "/usr/local/etc/salt/master.d/vault.conf"


def load_config():
    with open(get_config_path()) as fd:
        return yaml.safe_load(fd)


def connect_to_vault(verify):
    config = load_config()

    client = hvac.Client(url=config["vault"]["url"], verify=verify)
    client.auth.approle.login(
        role_id=config["vault"]["auth"]["role_id"],
        secret_id=config["vault"]["auth"]["secret_id"],
    )

    return client


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run(verify):
    client = connect_to_vault(verify)

    token = client.auth.token.create(role_name="admin", policies=["admin"], ttl="30d")
    print(token["auth"]["client_token"])


if __name__ == "__main__":
    verify_tls_certificate = VAULT_TLS_CERTIFICATE_PATH

    argc = len(sys.argv)

    if argc > 1:
        if sys.argv[1] == "--insecure":
            verify_tls_certificate = False
        else:
            print(f"Usage: {sys.argv[0]} [--insecure]", file=sys.stderr)
            sys.exit(1)

    run(verify_tls_certificate)
