# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — RabbitMQ execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Allow to use RabbitMQ management plugin HTTP API
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import base64
import hashlib
import secrets


#   -------------------------------------------------------------
#   Credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def compute_password_hash(password):
    salt = secrets.randbits(32)
    return _compute_password_hash_with_salt(salt, password)


def _compute_password_hash_with_salt(salt, password):
    """Reference: https://rabbitmq.com/passwords.html#computing-password-hash"""
    salt = salt.to_bytes(4, "big")  # salt is a 32 bits (4 bytes) value

    m = hashlib.sha256()
    m.update(salt)
    m.update(password.encode("utf-8"))
    result = salt + m.digest()

    return base64.b64encode(result).decode("utf-8")
