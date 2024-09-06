#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Monitoring :: GitHub :: storage quota
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Query storage quota on GitHub API
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import hvac
import requests
import yaml


VAULT_CERTIFICATE = "/usr/local/share/certs/nasqueron-vault-ca.crt"

ORG = "nasqueron"
STORAGE_THRESHOLD = 8


#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_config_path():
    # As long as we deploy primary servers on FreeBSD,
    # this path is stable.
    return "/usr/local/etc/monitoring/vault.conf"


def load_config():
    with open(get_config_path()) as fd:
        return yaml.safe_load(fd)


#   -------------------------------------------------------------
#   Fetch credential from Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def connect_to_vault():
    config = load_config()

    client = hvac.Client(url=config["vault"]["url"], verify=VAULT_CERTIFICATE)
    client.auth.approle.login(
        role_id=config["vault"]["auth"]["role_id"],
        secret_id=config["vault"]["auth"]["secret_id"],
    )

    return client


def read_github_token(vault_client):
    secret = vault_client.secrets.kv.read_secret_version(
        mount_point="apps",
        path="monitoring/github/token",
        raise_on_deleted_version=True,
    )

    return secret["data"]["data"]["password"]


#   -------------------------------------------------------------
#   GitHub :: shared storage billing
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def query_storage(org, token):
    url = f"https://api.github.com/orgs/{org}/settings/billing/shared-storage"
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28",
    }
    response = requests.get(url, headers=headers)

    return response.json()


#   -------------------------------------------------------------
#   Application entbry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run():
    vault_client = connect_to_vault()
    token = read_github_token(vault_client)

    storage = query_storage(ORG, token)
    used = int(storage["estimated_storage_for_month"])

    print(f"GitHub shared storage used (GB): {used}")

    if used >= STORAGE_THRESHOLD:
        exit(2)

    exit(0)


if __name__ == "__main__":
    run()
