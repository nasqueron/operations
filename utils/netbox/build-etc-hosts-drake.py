#!/usr/bin/env python3

#   -------------------------------------------------------------
#   NetBox — Build /etc/hosts for Drake private network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    This script queries NetBox to get IP and FQDN
#   Dependencies:   PyYAML, pynetbox
#   -------------------------------------------------------------


import logging
import os

import pynetbox
import yaml


VRF_RD_DRAKE = "nasqueron.drake"


#   -------------------------------------------------------------
#   Get NetBox config and credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_netbox_config_from_salt():
    config_path = "/usr/local/etc/salt/master.d/netbox.conf"

    if not os.path.exists(config_path):
        return False, None

    with open(config_path) as fd:
        salt_config = yaml.safe_load(fd)
        salt_config = salt_config["ext_pillar"][0]["netbox"]
        return True, {
            "server": salt_config["api_url"].replace("/api/", ""),
            "token": salt_config["api_token"],
        }


def get_netbox_config_from_config_dir():
    try:
        config_path = os.path.join(os.environ["HOME"], ".config", "netbox", "auth.yaml")
    except KeyError:
        return False, None

    if not os.path.exists(config_path):
        return False, None

    with open(config_path) as fd:
        return True, yaml.safe_load(fd)


def get_netbox_config():
    methods = [get_netbox_config_from_salt, get_netbox_config_from_config_dir]

    for method in methods:
        has_config, config = method()
        if has_config:
            return config

    raise RuntimeError("Can't find NetBox config")


#   -------------------------------------------------------------
#   Service container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def init_app():
    """Prepare a services container for appplication."""
    config = get_netbox_config()

    return {
        "config": config,
        "netbox": connect_to_netbox(config),
    }


def connect_to_netbox(config):
    return pynetbox.api(config["server"], token=config["token"])


#   -------------------------------------------------------------
#   Build /etc/hosts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def build_etc_hosts(nb):
    ip_addresses = nb.ipam.ip_addresses.filter(vrf=VRF_RD_DRAKE)
    for ip in ip_addresses:
        if len(ip.dns_name) == 0:
            continue

        if ip.status.value not in ["active", "deprecated"]:
            continue

        address = clean_ip(ip.address)
        short = get_short_dns_name(ip.dns_name)
        print(f"{address} {short} {ip.dns_name}")


#   -------------------------------------------------------------
#   Helper functions to use NetBox API
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def clean_ip(ip):
    pos = ip.find("/")
    return ip[0:pos]


def get_short_dns_name(hostname):
    pos = hostname.find(".")
    return hostname[0:pos]


#   -------------------------------------------------------------
#   Application entry-point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run_build_etc_hosts():
    app = init_app()
    build_etc_hosts(app["netbox"])


if __name__ == "__main__":
    LOGLEVEL = os.environ.get("LOGLEVEL", "WARNING").upper()
    logging.basicConfig(level=LOGLEVEL)

    run_build_etc_hosts()
