#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Salt - RabbitMQ management HTTP API state module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Configure RabbitMQ through management HTTP API
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import logging


log = logging.getLogger(__name__)


#   -------------------------------------------------------------
#   User
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def user_present(name, cluster, credential, tags=[]):
    password_hash = _get_password_hash(credential)
    return _user_present(name, cluster, password_hash=password_hash, tags=tags)


def _user_present(name, cluster, password_hash=None, tags=[]):
    ret = {"name": name, "result": False, "changes": {}, "comment": ""}

    expected = {
        "password_hash": password_hash,
        "tags": tags,
    }
    actual = {}
    is_existing = False

    if __salt__["rabbitmq_api.user_exists"](cluster, name):
        user = __salt__["rabbitmq_api.get_user"](cluster, name)
        is_existing = True
        actual = {
            "password_hash": user["password_hash"],
            "tags": user["tags"],
        }

    if actual == expected:
        ret["result"] = True
        ret["comment"] = f"User {name} is up to date"
        return ret

    ret["changes"] = _changes(actual, expected)
    update_verb = "updated" if is_existing else "created"

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = f"User {name} will be {update_verb}"
        return ret

    try:
        __salt__["rabbitmq_api.update_user"](cluster, name, **expected)
    except Exception as e:
        e = str(e)
        log.error("Can't update RabbitMQ user: " + e)
        ret["comment"] = e
        return ret

    ret["result"] = True
    ret["comment"] = f"User {update_verb}"

    return ret


def user_absent(name, cluster):
    ret = {"name": name, "result": False, "changes": {}, "comment": ""}

    if not __salt__["rabbitmq_api.user_exists"](cluster, name):
        ret["result"] = True
        ret["comment"] = f"User {name} is absent"
        return ret

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = f"User {name} will be deleted"
        return ret

    try:
        __salt__["rabbitmq_api.delete_user"](cluster, name)
    except Exception as e:
        e = str(e)
        log.error("Can't delete RabbitMQ user: " + e)
        ret["comment"] = e
        return ret

    ret["result"] = True
    ret["comment"] = "User deleted"

    return ret


def user_permissions(name, cluster, vhost, user, permissions={}):
    ret = {"name": name, "result": False, "changes": {}, "comment": ""}

    expected = permissions | {"vhost": vhost, "user": user}
    actual = {}
    is_existing = False

    try:
        actual = __salt__["rabbitmq_api.get_permissions"](cluster, vhost, user)
        is_existing = True
    except RuntimeError as e:
        if "404" not in str(e):
            raise e

    if actual == expected:
        ret["result"] = True
        ret["comment"] = "Permission is up-to-date"
        return ret

    ret["changes"] = _changes(actual, expected)
    update_verb = "updated" if is_existing else "created"

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = f"User permissions will be {update_verb}"
        return ret

    try:
        __salt__["rabbitmq_api.update_permissions"](cluster, vhost, user, **permissions)
    except Exception as e:
        e = str(e)
        log.error("Can't update RabbitMQ user permissions: " + e)
        ret["comment"] = e
        return ret

    ret["result"] = True
    ret["comment"] = f"User permissions {update_verb}"

    return ret


#   -------------------------------------------------------------
#   Vhost
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def vhost_present(name, cluster, description="", tags=[], tracing=False):
    ret = {"name": name, "result": False, "changes": {}, "comment": ""}

    expected = {
        "description": description,
        "tags": tags,
        "tracing": tracing,
    }
    actual = {}
    is_existing = False

    if __salt__["rabbitmq_api.vhost_exists"](cluster, name):
        vhost = __salt__["rabbitmq_api.get_vhost"](cluster, name)
        is_existing = True
        actual = {
            "description": vhost["metadata"]["description"],
            "tags": vhost["metadata"]["tags"],
            "tracing": vhost["tracing"],
        }

    if actual == expected:
        ret["result"] = True
        ret["comment"] = f"Vhost {name} is up to date"
        return ret

    ret["changes"] = _changes(actual, expected)
    update_verb = "updated" if is_existing else "created"

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = f"Vhost {name} will be {update_verb}"
        return ret

    try:
        __salt__["rabbitmq_api.update_vhost"](cluster, name, **expected)
    except Exception as e:
        e = str(e)
        log.error("Can't update RabbitMQ vhost: " + e)
        ret["comment"] = e
        return ret

    ret["result"] = True
    ret["comment"] = f"Vhost {update_verb}"

    return ret


def vhost_absent(name, cluster):
    ret = {"name": name, "result": False, "changes": {}, "comment": ""}

    if not __salt__["rabbitmq_api.vhost_exists"](cluster, name):
        ret["result"] = True
        ret["comment"] = f"Vhost {name} is absent"
        return ret

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = f"Vhost {name} will be deleted"
        return ret

    try:
        __salt__["rabbitmq_api.delete_vhost"](cluster, name)
    except Exception as e:
        e = str(e)
        log.error("Can't delete RabbitMQ vhost: " + e)
        ret["comment"] = e
        return ret

    ret["result"] = True
    ret["comment"] = "Vhost deleted"

    return ret


#   -------------------------------------------------------------
#   Exchange
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def exchange_present(
    name,
    cluster,
    vhost,
    type,
    auto_delete=False,
    durable=False,
    internal=False,
    arguments={},
):
    ret = {"name": name, "result": False, "changes": {}, "comment": ""}

    expected = {
        "type": type,
        "auto_delete": auto_delete,
        "durable": durable,
        "internal": internal,
        "arguments": arguments,
    }
    actual = {}
    is_existing = False

    if __salt__["rabbitmq_api.exchange_exists"](cluster, vhost, name):
        exchange = __salt__["rabbitmq_api.get_exchange"](cluster, vhost, name)
        is_existing = True
        actual = {
            "type": exchange["type"],
            "auto_delete": exchange["auto_delete"],
            "durable": exchange["durable"],
            "internal": exchange["internal"],
            "arguments": exchange["arguments"],
        }

    if actual == expected:
        ret["result"] = True
        ret["comment"] = f"Exchange {name} is up to date"
        return ret

    ret["changes"] = _changes(actual, expected)
    update_verb = "deleted then created back" if is_existing else "created"

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = f"Exchange {name} will be {update_verb}"
        return ret

    try:
        if is_existing:
            operation = "delete"
            __salt__["rabbitmq_api.delete_exchange"](cluster, vhost, name)

        operation = "create"
        __salt__["rabbitmq_api.update_exchange"](cluster, vhost, name, **expected)
    except Exception as e:
        e = str(e)
        log.error(f"Can't {operation} RabbitMQ exchange: {e}")
        ret["comment"] = e
        return ret

    ret["result"] = True
    ret["comment"] = f"Exchange {update_verb}"

    return ret


#   -------------------------------------------------------------
#   Queue
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def queue_present(
    name, cluster, vhost, auto_delete=False, durable=False, arguments={}, node=None
):
    ret = {"name": name, "result": False, "changes": {}, "comment": ""}

    expected = {
        "auto_delete": auto_delete,
        "durable": durable,
        "arguments": arguments,
    }
    if node is not None:
        expected["node"] = node

    actual = {}
    is_existing = False

    if __salt__["rabbitmq_api.queue_exists"](cluster, vhost, name):
        queue = __salt__["rabbitmq_api.get_queue"](cluster, vhost, name)
        is_existing = True
        actual = {
            "auto_delete": queue["auto_delete"],
            "durable": queue["durable"],
            "arguments": queue["arguments"],
        }
        if node is not None:
            actual["node"] = queue["node"]

    if actual == expected:
        ret["result"] = True
        ret["comment"] = f"queue {name} is up to date"
        return ret

    ret["changes"] = _changes(actual, expected)
    update_verb = "deleted then created back" if is_existing else "created"

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = f"queue {name} will be {update_verb}"
        return ret

    try:
        if is_existing:
            operation = "delete"
            __salt__["rabbitmq_api.delete_queue"](cluster, vhost, name)

        operation = "create"
        __salt__["rabbitmq_api.update_queue"](cluster, vhost, name, **expected)
    except Exception as e:
        e = str(e)
        log.error(f"Can't {operation} RabbitMQ queue: {e}")
        ret["comment"] = e
        return ret

    ret["result"] = True
    ret["comment"] = f"queue {update_verb}"

    return ret


def queue_binding(name, cluster, vhost, queue, exchange, routing_key="#", arguments={}):
    ret = {"name": name, "result": False, "changes": {}, "comment": ""}

    expected = {
        "routing_key": routing_key,
        "arguments": arguments,
    }

    if __salt__["rabbitmq_api.check_queue_binding"](
        cluster, vhost, queue, exchange, routing_key=routing_key, arguments=arguments
    ):
        ret["result"] = True
        ret["comment"] = "Queue already bound"
        return ret

    ret["changes"] = expected

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "Binding will be created"
        return ret

    try:
        __salt__["rabbitmq_api.queue_bind"](cluster, vhost, exchange, queue, **expected)
    except Exception as e:
        e = str(e)
        log.error("Can't create RabbitMQ binding: " + e)
        ret["comment"] = e
        return ret

    ret["result"] = True
    ret["comment"] = "Binding created"

    return ret


#   -------------------------------------------------------------
#   Helper functions
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def _get_password_hash(credential):
    secret = __salt__["vault.read_secret"](credential)
    salt = int(secret["salt"], 16)
    return __salt__["rabbitmq_api.compute_password_hash_with_salt"](
        salt, secret["password"]
    )


def _changes(actual, expected):
    """Compute a changes dictionary between actual and expected state dictionaries."""
    changes = {}
    for key, value in expected.items():
        if key in actual and actual[key] == expected[key]:
            continue

        if "password" in key:
            value = "*****"

        if key not in actual:
            old_value = None
        elif "password" in key:
            old_value = "*****"
        else:
            old_value = actual[key]

        changes[key] = {"old": old_value, "new": value}

    return changes
