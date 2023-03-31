#   -------------------------------------------------------------
#   Salt — Node execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Build Notifications center configuration
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import copy


def get_credentials():
    try:
        services = __pillar__["notifications_credentials"]["services"]
    except KeyError:
        services = []

    return {"services": [_build_service_config(service) for service in services]}


def _build_service_config(service):
    built_service = copy.deepcopy(service)

    if "secret" in service:
        built_service["secret"] = __salt__["credentials.get_token"](service["secret"])

    return built_service


#   -------------------------------------------------------------
#   Build triggers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_dockerhub_triggers():
    repositories = __pillar__.get("notifications_dockerhub_triggers", {})
    return {
        repository: _get_dockerhub_trigger(key)
        for repository, key in repositories.items()
    }


def _get_dockerhub_trigger(key):
    secret = __salt__["vault.read_secret"](key)
    return {
        "source": secret["source"],
        "trigger": secret["trigger"],
    }
