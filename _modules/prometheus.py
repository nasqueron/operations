#   -------------------------------------------------------------
#   Salt — Prometheus execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Functions related to Prometheus configuration
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


SCRAPE_CONFIG_OPTIONS_RENAME = {
    "name": "job_name",
}

SCRAPE_CONFIG_OPTIONS_PASSTHROUGH = [
    "scheme",
    "metrics_path",
]


def get_scrape_configs():
    configs = __pillar__.get("prometheus_scrape_jobs", {}).values()
    return [_build_scrape_config(config) for config in configs]


def _build_scrape_config(config):
    scrape_config = {}

    for key in SCRAPE_CONFIG_OPTIONS_PASSTHROUGH:
        if key in config:
            scrape_config[key] = config[key]

    for pillar_key, scrape_config_key in SCRAPE_CONFIG_OPTIONS_RENAME.items():
        if pillar_key in config:
            scrape_config[scrape_config_key] = config[pillar_key]

    scrape_targets = []

    for target in config.get("services_targets", []):
        address = _resolve_service(target)
        scrape_targets.append(address)

    for targets in config.get("services_targets_list", []):
        addresses = _resolve_service_list(targets)
        scrape_targets.extend(addresses)

    scrape_config["static_configs"] = [{"targets": scrape_targets}]

    return scrape_config


def _resolve_service(config):
    if "service" not in config or "port" not in config:
        raise ValueError("service and port keys are both required to define a service")

    key = "nasqueron_services:" + config["service"]
    address = __salt__["pillar.get"](key)

    return address + ":" + str(config["port"])


def _resolve_service_list(config):
    if "service" not in config or "port" not in config:
        raise ValueError("service and port keys are both required to define a service")

    key = "nasqueron_services:" + config["service"]
    addresses = __salt__["pillar.get"](key)

    return [address + ":" + str(config["port"]) for address in addresses]
