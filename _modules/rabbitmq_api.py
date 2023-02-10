#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Salt - RabbitMQ management HTTP API client
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Connect to RabbitMQ management HTTP API
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import base64
import hashlib
import json
import logging
import secrets

import requests
from requests.auth import HTTPBasicAuth


log = logging.getLogger(__name__)


HTTP_SUCCESS_CODES = [200, 201, 204]
HTTP_CONTENT_CODES = [200]


#   -------------------------------------------------------------
#   RabbitMQ management HTTP API client
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def _request(cluster, method, path, data=None):
    args = __opts__["rabbitmq"][cluster]

    url = args["url"] + "/" + path

    if args["auth"] == "basic":
        auth = HTTPBasicAuth(args["user"], args["password"])
    else:
        raise RuntimeError(
            f"RabbitMQ HTTP API authentication scheme not supported: {args['auth']}"
        )

    headers = {
        "User-agent": "Salt-RabbitMQ/1.0",
    }

    if data is not None:
        data = json.dumps(data)

    log.debug(f"HTTP request {method} to {url}")
    log.trace(f"Payload: {data}")
    r = requests.request(method, url, headers=headers, auth=auth, data=data)

    if r.status_code not in HTTP_SUCCESS_CODES:
        log.error(f"HTTP status code {r.status_code}, 2xx expected.")
        raise RuntimeError(f"Status code is {r.status_code}")

    if r.status_code not in HTTP_CONTENT_CODES:
        log.trace(
            f"HTTP response is {r.status_code}. The API doesn't include any content for this code."
        )
        return True

    return r.json()


#   -------------------------------------------------------------
#   Execution module methods
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


ARGS_USER = ["password_hash", "tags"]
ARGS_VHOST = ["description", "tags", "tracing"]
ARGS_EXCHANGE = ["type", "auto_delete", "durable", "internal", "arguments"]
ARGS_QUEUE = ["auto_delete", "durable", "arguments", "node"]
ARGS_BINDING = ["routing_key", "arguments"]


def overview(cluster):
    return _request(cluster, "GET", "overview")


def list_users(cluster):
    return _request(cluster, "GET", "users")


def get_user(cluster, user):
    user = requests.utils.quote(user, safe="")
    return _request(cluster, "GET", f"users/{user}")


def update_user(cluster, user, **kwargs):
    user = requests.utils.quote(user, safe="")
    data = {}
    for arg in ARGS_USER:
        if arg in kwargs:
            data[arg] = kwargs[arg]

    if "password" in kwargs:
        if "password_hash" in kwargs:
            raise RuntimeError(
                "You can't specify both password and password_hash option."
            )
        data["password_hash"] = compute_password_hash(kwargs["password"])

    return _request(cluster, "PUT", f"users/{user}", data)


def delete_user(cluster, user):
    user = requests.utils.quote(user, safe="")
    return _request(cluster, "DELETE", f"users/{user}")


def user_exists(cluster, user):
    return user in [result["name"] for result in list_users(cluster)]


def list_vhosts(cluster):
    return _request(cluster, "GET", "vhosts")


def get_vhost(cluster, vhost):
    vhost = requests.utils.quote(vhost, safe="")
    return _request(cluster, "GET", f"vhosts/{vhost}")


def update_vhost(cluster, vhost, **kwargs):
    vhost = requests.utils.quote(vhost, safe="")
    data = {}
    for arg in ARGS_VHOST:
        if arg in kwargs:
            data[arg] = kwargs[arg]

    return _request(cluster, "PUT", f"vhosts/{vhost}", data)


def delete_vhost(cluster, vhost):
    vhost = requests.utils.quote(vhost, safe="")
    return _request(cluster, "DELETE", f"vhosts/{vhost}")


def vhost_exists(cluster, vhost):
    return vhost in [result["name"] for result in list_vhosts(cluster)]


def list_exchanges(cluster, vhost):
    vhost = requests.utils.quote(vhost, safe="")
    return _request(cluster, "GET", f"exchanges/{vhost}")


def get_exchange(cluster, vhost, exchange):
    vhost = requests.utils.quote(vhost, safe="")
    exchange = requests.utils.quote(exchange, safe="")
    return _request(cluster, "GET", f"exchanges/{vhost}/{exchange}")


def update_exchange(cluster, vhost, exchange, **kwargs):
    vhost = requests.utils.quote(vhost, safe="")
    exchange = requests.utils.quote(exchange, safe="")
    data = {}
    for arg in ARGS_EXCHANGE:
        if arg in kwargs:
            data[arg] = kwargs[arg]

    return _request(cluster, "PUT", f"exchanges/{vhost}/{exchange}", data)


def delete_exchange(cluster, vhost, exchange):
    vhost = requests.utils.quote(vhost, safe="")
    exchange = requests.utils.quote(exchange, safe="")
    return _request(cluster, "DELETE", f"exchanges/{vhost}/{exchange}")


def exchange_exists(cluster, vhost, exchange):
    vhost = requests.utils.quote(vhost, safe="")
    return exchange in [result["name"] for result in list_exchanges(cluster, vhost)]


def list_queues(cluster, vhost):
    vhost = requests.utils.quote(vhost, safe="")
    return _request(cluster, "GET", f"queues/{vhost}")


def get_queue(cluster, vhost, queue):
    vhost = requests.utils.quote(vhost, safe="")
    queue = requests.utils.quote(queue, safe="")
    return _request(cluster, "GET", f"queues/{vhost}/{queue}")


def update_queue(cluster, vhost, queue, **kwargs):
    vhost = requests.utils.quote(vhost, safe="")
    queue = requests.utils.quote(queue, safe="")

    data = {}
    for arg in ARGS_QUEUE:
        if arg in kwargs:
            data[arg] = kwargs[arg]

    return _request(cluster, "PUT", f"queues/{vhost}/{queue}", data)


def delete_queue(cluster, vhost, queue):
    vhost = requests.utils.quote(vhost, safe="")
    queue = requests.utils.quote(queue, safe="")
    return _request(cluster, "DELETE", f"queues/{vhost}/{queue}")


def queue_exists(cluster, vhost, queue):
    vhost = requests.utils.quote(vhost, safe="")
    return queue in [result["name"] for result in list_queues(cluster, vhost)]


def list_bindings(cluster, vhost):
    vhost = requests.utils.quote(vhost, safe="")
    return _request(cluster, "GET", f"bindings/{vhost}")


def check_queue_binding(cluster, vhost, queue, exchange, **kwargs):
    bindings = list_bindings(cluster, vhost)
    for binding in bindings:
        # The binding is the one we want if all fields are equal
        if binding["source"] != exchange:
            continue
        if binding["destination_type"] != "queue":
            continue
        if binding["destination"] != queue:
            continue
        for arg in ARGS_BINDING:
            if binding[arg] != kwargs[arg]:
                continue

        # We've got a winner
        return True

    return False


def check_exchange_binding(cluster, vhost, source, destination, **kwargs):
    bindings = list_bindings(cluster, vhost)
    for binding in bindings:
        # The binding is the one we want if all fields are equal
        if binding["source"] != source:
            continue
        if binding["destination_type"] != "exchange":
            continue
        if binding["destination"] != destination:
            continue
        for arg in ARGS_BINDING:
            if binding[arg] != kwargs[arg]:
                continue

        # We've got a winner
        return True

    return False


def queue_bind(cluster, vhost, exchange, queue, **kwargs):
    vhost = requests.utils.quote(vhost, safe="")
    queue = requests.utils.quote(queue, safe="")
    exchange = requests.utils.quote(exchange, safe="")

    data = {}
    for arg in ARGS_BINDING:
        if arg in kwargs:
            data[arg] = kwargs[arg]

    return _request(cluster, "POST", f"bindings/{vhost}/e/{exchange}/q/{queue}", data)


def exchange_bind(cluster, vhost, source, destination, **kwargs):
    vhost = requests.utils.quote(vhost, safe="")
    source = requests.utils.quote(source, safe="")
    destination = requests.utils.quote(destination, safe="")

    data = {}
    for arg in ARGS_BINDING:
        if arg in kwargs:
            data[arg] = kwargs[arg]

    return _request(
        cluster, "POST", f"bindings/{vhost}/e/{source}/e/{destination}", data
    )


def get_permissions(cluster, vhost, user):
    return _request(cluster, "GET", f"permissions/{vhost}/{user}")


def update_permissions(cluster, vhost, user, **kwargs):
    data = {
        "configure": "^$",
        "read": "^$",
        "write": "^$",
    }

    for arg in data:
        if arg in kwargs:
            if kwargs[arg]:
                data[arg] = kwargs[arg]

    return _request(cluster, "PUT", f"permissions/{vhost}/{user}", data)


#   -------------------------------------------------------------
#   Credentials helper methods
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def compute_password_hash(password):
    salt = secrets.randbits(32)
    return compute_password_hash_with_salt(salt, password)


def compute_password_hash_with_salt(salt, password):
    """Reference: https://rabbitmq.com/passwords.html#computing-password-hash"""
    salt = salt.to_bytes(4, "big")  # salt is a 32 bits (4 bytes) value

    m = hashlib.sha256()
    m.update(salt)
    m.update(password.encode("utf-8"))
    result = salt + m.digest()

    return base64.b64encode(result).decode("utf-8")
