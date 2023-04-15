#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Salt :: tests :: config :: RabbitMQ
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Connect to RabbitMQ
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import sys

import yaml
import requests
from requests.auth import HTTPBasicAuth


def get_config_path():
    # As long as we deploy primary servers on FreeBSD,
    # this path is stable.
    return "/usr/local/etc/salt/master.d/rabbitmq.conf"


def load_config():
    with open(get_config_path()) as fd:
        return yaml.safe_load(fd)


def connect_to_rabbitmq(args):
    url = args["url"] + "/overview"

    if args["auth"] == "basic":
        auth = HTTPBasicAuth(args["user"], args["password"])
    else:
        raise RuntimeError(
            f"RabbitMQ HTTP API authentication scheme not supported: {args['auth']}"
        )

    r = requests.get(url, auth=auth)
    if r.status_code != 200:
        return False

    return True


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run_tests():
    overall_result = True
    clusters = load_config()["rabbitmq"]
    for cluster, args in clusters.items():
        result = "✔️"
        if not connect_to_rabbitmq(args):
            result = "❌"
            overall_result = False
        print(f"{cluster}\t{result}")

    return overall_result


if __name__ == "__main__":
    is_success = run_tests()
    sys.exit(0 if is_success else 1)
