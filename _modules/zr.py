# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Zemke-Rhyne module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-11
#   Description:    Fetch Zemke-Rhyne credentials
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import os

from salt.utils.path import which as path_which


def __virtual__():
    """
    Only load if zr exists on the system
    """
    return (
        path_which("zr") is not None,
        "The Zemke-Rhyne execution module cannot be loaded: zr not installed.",
    )


def _are_credentials_hidden():
    return "CONFIG_PUBLISHER" in os.environ or "state.show_sls" in os.environ.get(
        "SUDO_COMMAND", ""
    )


def _build_pillar_key(expression):
    return "zr_credentials:" + expression.replace(".", ":")


def _get_credential_id_from_pillar_key(expression):
    """Gets credentials id from a dot pillar path, e.g. nasqueron.foo.bar"""
    key = _build_pillar_key(expression)
    return __salt__["pillar.get"](key)


def get_credential_id(expression):
    try:
        # Case I - expression is an integer
        number = int(expression)

        if number < 1:
            raise ValueError(expression, "A strictly positive integer was expected.")

        return number
    except ValueError:
        # Case II - expression is a pillar key
        credential_id = _get_credential_id_from_pillar_key(expression)

        if credential_id is None or credential_id == "":
            raise ValueError(expression, "Pillar key not found")

        return credential_id


def get_password(credential_expression):
    """
    A function to fetch credential through Zemke-Rhyne


    CLI Example:

        salt equatower  zr.get_password 124

    :param credential_expression: The credential number (K...) in Phabricator
                                  or a key in zr_credentials pillar entry
    :return: The secret value
    """
    if _are_credentials_hidden():
        return "credential for " + credential_expression

    credential_id = get_credential_id(credential_expression)

    zr_command = "zr getcredentials {0}".format(credential_id)
    return __salt__["cmd.shell"](zr_command)


def get_username(credential_expression):
    """
    A function to fetch the username associated to a credential
    through Zemke-Rhyne

    CLI Example:

        salt equatower zr.get_username 124

    :param credential_expression: The credential number (K...) in Phabricator
                                  or a key in zr_credentials pillar entry

    :return: The username
    """
    credential_id = get_credential_id(credential_expression)

    zr_command = "zr getcredentials {0} username".format(credential_id)
    return __salt__["cmd.shell"](zr_command)


def get_token(credential_expression):
    """
    A function to fetch credential through Zemke-Rhyne


    CLI Example:

        salt equatower zr.get_token 126

    :param credential_expression: The credential number (K...) in Phabricator
                                  or a key in zr_credentials pillar entry
    :return: The secret value
    """
    if _are_credentials_hidden():
        return "credential for " + credential_expression

    credential_id = get_credential_id(credential_expression)

    zr_command = "zr getcredentials {0} token".format(credential_id)
    return __salt__["cmd.shell"](zr_command)


def generate_random(secret_len):
    """
    A function to generate a random credential
    """
    if _are_credentials_hidden():
        return "random credential"

    return __salt__["random.get_str"](secret_len)


def get_sentry_dsn(args):
    sentry_server = _get_sentry_server(args["realm"])

    if _are_credentials_hidden():
        return (
            "https://[…]@"
            + sentry_server
            + "/"
            + str(args["project_id"])
            + " with credential for "
            + args["credential"]
        )

    return (
        "https://"
        + ":".join(
            [
                get_username(args["credential"]),
                get_password(args["credential"]),
            ]
        )
        + "@"
        + sentry_server
        + "/"
        + str(args["project_id"])
    )


def _get_sentry_server(realm):
    return __pillar__["sentry_realms"][realm]["host"]
