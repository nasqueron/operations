#!py

#   -------------------------------------------------------------
#   Salt — RabbitMQ
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#                   If eligible, licensed under BSD-2-Clause
#   -------------------------------------------------------------


#   -------------------------------------------------------------
#   Configuration provider
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run():
    config = {}

    for cluster, cluster_args in __pillar__["rabbitmq_clusters"].items():
        config |= configure_cluster(cluster, cluster_args)

    return config


#   -------------------------------------------------------------
#   Cluster configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def configure_cluster(cluster, cluster_args):
    config = {}

    for user, credential in cluster_args["users"].items():
        id = f"rabbitmq_cluster_{cluster}_user_{user}"
        config[id] = configure_user(cluster, user, credential)

    for vhost, vhost_args in cluster_args["vhosts"].items():
        id = f"rabbitmq_cluster_{cluster}_vhost_{vhost}"
        config[id] = configure_vhost(cluster, vhost, vhost_args)

        for exchange, exchange_args in vhost_args.get("exchanges", {}).items():
            id = f"rabbitmq_cluster_{cluster}_vhost_{vhost}_exchange_{exchange}"
            config[id] = configure_exchange(cluster, vhost, exchange, exchange_args)

        for queue, queue_args in vhost_args.get("queues", {}).items():
            id = f"rabbitmq_cluster_{cluster}_vhost_{vhost}_queue_{queue}"
            config[id] = configure_queue(cluster, vhost, queue, queue_args)

        i = 0
        for binding in vhost_args.get("bindings", []):
            i += 1
            id = f"rabbitmq_cluster_{cluster}_vhost_{vhost}_binding_{i}"
            config[id] = configure_binding(cluster, vhost, binding)

        for user, permission in vhost_args.get("permissions", {}).items():
            id = f"rabbitmq_cluster_{cluster}_vhost_{vhost}_permissions_user_{user}"
            config[id] = configure_user_permission(cluster, vhost, user, permission)

    return config


#   -------------------------------------------------------------
#   RabbitMQ vhosts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def configure_vhost(cluster, vhost, vhost_args):
    return {
        "rabbitmq.vhost_present": [
            {"name": vhost},
            {"cluster": cluster},
            {"description": vhost_args.get("description", "")},
        ]
    }


#   -------------------------------------------------------------
#   RabbitMQ exchanges and queues
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def configure_exchange(cluster, vhost, exchange, exchange_args):
    return {
        "rabbitmq.exchange_present": [
            {"name": exchange},
            {"cluster": cluster},
            {"vhost": vhost},
            {"type": exchange_args["type"]},
            {"durable": exchange_args.get("durable", False)},
        ]
    }


def configure_queue(cluster, vhost, queue, queue_args):
    return {
        "rabbitmq.queue_present": [
            {"name": queue},
            {"cluster": cluster},
            {"vhost": vhost},
            {"durable": queue_args.get("durable", False)},
        ]
    }


def configure_binding(cluster, vhost, binding):
    params = [
        {"queue": binding["queue"]},
        {"cluster": cluster},
        {"vhost": vhost},
        {"exchange": binding["exchange"]},
    ]

    if "routing_key" in binding:
        params.append({"routing_key": binding["routing_key"]})

    return {"rabbitmq.queue_binding": params}


#   -------------------------------------------------------------
#   RabbitMQ users and permissions
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def configure_user(cluster, user, credential):
    return {
        "rabbitmq.user_present": [
            {"name": user},
            {"cluster": cluster},
            {"credential": credential},
        ]
    }


def configure_user_permission(cluster, vhost, user, privilege):
    return {
        "rabbitmq.user_permissions": [
            {"cluster": cluster},
            {"vhost": vhost},
            {"user": user},
            {"permissions": privilege},
        ]
    }
