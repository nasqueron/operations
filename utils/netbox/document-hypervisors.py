#!/usr/bin/env python3

#   -------------------------------------------------------------
#   NetBox — Document hypervisors facts in NetBox
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    This script connects to hypervisors,
#                   gather facts like last version used,
#                   and document them to NetBox config context.
#   Dependencies:   PyYAML, pynetbox
#   -------------------------------------------------------------


import logging
import os
import sys

import pynetbox
import subprocess
import yaml


TAG_VMWARE = "VMWare ESXi"


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
    """Prepare a service container for application."""
    config = get_netbox_config()

    return {
        "config": config,
        "netbox": connect_to_netbox(config),
    }


def connect_to_netbox(config):
    return pynetbox.api(config["server"], token=config["token"])


#   -------------------------------------------------------------
#   Document hypervisors
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def document_hypervisors(app):
    logging.info("Query NetBox DCIM to get devices")
    devices = app["netbox"].dcim.devices.all()
    for device in devices:
        if is_device_tagged(device, TAG_VMWARE):
            document_vmware_hypervisor(app["netbox"], device)


def document_vmware_hypervisor(nb, device):
    logging.info(f"Documenting {device.name}")

    ip = get_device_primary_ip_address(device)
    logging.info(f"Connecting to {ip}")
    version = ssh(ip, ["vmware", "-v"])
    logging.debug(f"Version found: {version}")

    update_actual_context_version(device, version)


#   -------------------------------------------------------------
#   Helper functions to use NetBox API
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def is_device_tagged(device, tag):
    tags = [tag.name for tag in device.tags]
    return tag in tags


def get_device_primary_ip_address(device):
    pos = device.primary_ip.address.find("/")
    return device.primary_ip.address[0:pos]


def update_actual_context_version(device, version):
    try:
        current_version = device.local_context_data["actual_context"]["version"]
        if version == current_version:
            return
    except KeyError:
        pass

    if "actual_context" not in device.local_context_data:
        device.local_context_data["actual_context"] = {}

    device.local_context_data["actual_context"]["version"] = version
    logging.info(f"Saving new local context for {device.name}: version is {version}")
    device.save()


#   -------------------------------------------------------------
#   Helper functions to use SSH
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def ssh(host, command):
    return run_process(["ssh", host, *command])


def run_process(command):
    process = subprocess.run(command, capture_output=True)

    if process.returncode == 0:
        return process.stdout.decode("UTF-8").strip()

    if len(process.stderr) > 0:
        print(process.stderr.decode("UTF-8").strip(), file=sys.stderr)
        logging.warning(
            f"When running {command}: {process.stderr} (exit code: {process.returncode})"
        )
        return None


#   -------------------------------------------------------------
#   Application entry-point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run_document_hypervisors():
    app = init_app()
    document_hypervisors(app)


if __name__ == "__main__":
    LOGLEVEL = os.environ.get("LOGLEVEL", "WARNING").upper()
    logging.basicConfig(level=LOGLEVEL)

    run_document_hypervisors()
