#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Docker PaaS - List of containers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Resolve the dependencies between containers
#                   into a graph, and use topological sorting
#                   to offer an order of containers.
#
#                   This can be used to run every container in
#                   the right order to avoid any link issue.
#
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


from graphlib import TopologicalSorter
import json
import subprocess
import sys


CONTAINER_DELIMITERS = [":"]


#   -------------------------------------------------------------
#   Resolve dependencies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def solve_containers_order(containers, dependencies):
    graph = {}

    for service, instances in containers.items():
        if service not in dependencies:
            graph |= {instance: [] for instance in instances}
            continue

        rules = dependencies[service]
        for instance, args in instances.items():
            graph[instance] = solve_dependencies(containers, rules, instance, args)

    return list(TopologicalSorter(graph).static_order())


def solve_dependencies(containers, rules, instance, args):
    other_instances = []

    if "depends_of_containers" in rules:
        other_instances += [
            get_value(args, container_key)
            for container_key in rules["depends_of_containers"]
        ]

    if "may_depends_of_containers" in rules:
        other_instances += [
            get_value(args, container_key)
            for container_key in rules["may_depends_of_containers"]
            if container_key in args
        ]

    if "depends_of_services" in rules:
        if "network" not in args:
            print(
                f"[WARN] Can't resolve depends_of_services rule for instance {instance} as no network is specified.",
                file=sys.stderr,
            )
            return other_instances

        for service in rules["depends_of_services"]:
            for other_instance, other_args in containers[service].items():
                if "network" not in other_args:
                    # For example, pixelfed_redis isn't on a network
                    continue

                if args["network"] == other_args["network"]:
                    other_instances.append(other_instance)

    return other_instances


#   -------------------------------------------------------------
#   Helper methods to get and clean container values
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def clean_value(container):
    for delimiter in CONTAINER_DELIMITERS:
        pos = container.find(delimiter)
        if pos > -1:
            container = container[:pos]

    return container


def get_value(args, key):
    if "." in key:
        pos = key.find(".")
        return get_value(args[key[:pos]], key[pos + 1 :])

    try:
        return clean_value(args[key])
    except KeyError:
        print(f"[FATAL] No {key} in {args}", file=sys.stderr)
        sys.exit(1)


#   -------------------------------------------------------------
#   Helper methods to query Salt pillar
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def query_pillar(*keys):
    cmd = ["sudo", "salt-call", "pillar.items", "--out", "json"]
    process = subprocess.run(cmd, capture_output=True)

    if process.returncode != 0:
        raise RuntimeError("Can't query Salt: " + process.stderr)

    pillar = json.loads(process.stdout)["local"]
    return tuple(pillar.get(key, {}) for key in keys)


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run():
    try:
        containers, dependencies = query_pillar(
            "docker_containers", "docker_containers_dependencies"
        )
    except RuntimeError as e:
        print(e, file=sys.stderr)
        sys.exit(2)

    for container in solve_containers_order(containers, dependencies):
        print(container)


if __name__ == "__main__":
    run()
