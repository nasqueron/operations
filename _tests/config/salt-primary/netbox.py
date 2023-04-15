#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Salt :: tests :: config :: NetBox
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Connect to NetBox API
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import yaml
import requests
import sys


def get_config_path():
    # As long as we deploy primary servers on FreeBSD,
    # this path is stable.
    return "/usr/local/etc/salt/master.d/netbox.conf"


def load_config():
    with open(get_config_path()) as fd:
        return yaml.safe_load(fd)


def connect_to_netbox():
    config = load_config()
    try:
        config = config["ext_pillar"][0]["netbox"]
    except KeyError:
        print(
            "Invalid configuration format. See https://docs.saltproject.io/en/latest/ref/pillar/all/salt.pillar.netbox.html for the expected format.",
            file=sys.stderr,
        )
        return False

    url = config["api_url"] + "dcim/devices/"
    headers = {"Authorization": f"Token {config['api_token']}"}
    r = requests.get(url, headers=headers)
    if r.status_code != 200:
        return False

    try:
        if url not in r.json()["results"][0]["url"]:
            print(
                "Test request to list devices. Device URL was expected to match API URL.",
                file=sys.stderr,
            )
            return False
    except KeyError:
        print("Request format not recognized. API response changed?", file=sys.stderr)
        return False

    return True


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run_tests():
    return connect_to_netbox()


if __name__ == "__main__":
    is_success = run_tests()
    sys.exit(0 if is_success else 1)
