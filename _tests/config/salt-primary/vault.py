#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Salt :: tests :: config :: Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Connect to Vault
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import yaml
import json
import requests
import sys


def get_config_path():
    # As long as we deploy primary servers on FreeBSD,
    # this path is stable.
    return "/usr/local/etc/salt/master.d/vault.conf"


def load_config():
    with open(get_config_path()) as fd:
        return yaml.safe_load(fd)


def connect_to_vault():
    config = load_config()

    authdata = json.dumps(config["vault"]["auth"])
    url = config["vault"]["url"] + "/v1/auth/approle/login"
    r = requests.post(url, verify=config["vault"]["verify"], data=authdata)
    if r.status_code != 200:
        return False

    auth = r.json()["auth"]
    print("Can connect to Vault:")
    for k in ["metadata", "policies", "token_policies", "token_type"]:
        print(f"\t{k}: {auth[k]}")
    return True


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run_tests():
    return connect_to_vault()


if __name__ == "__main__":
    is_success = run_tests()
    sys.exit(0 if is_success else 1)
