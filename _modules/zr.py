# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Zemke-Rhyne module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-11
#   Description:    Fetch Zemke-Rhyne credentials
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


from salt.utils.path import which as path_which


def __virtual__():
    '''
    Only load if zr exists on the system
    '''
    return path_which('zr') is not None,\
        "The Zemke-Rhyne execution module cannot be loaded: zr not installed."


def _assert_stricly_positive_integer(value):
    try:
        number = int(value)
        if number < 1:
            raise ValueError(
                value, "A strictly positive integer was expected.")
    except ValueError:
        raise


def get_password(credential_id):
    """
    A function to fetch credential through Zemke-Rhyne


    CLI Example:

        salt equatower  zr.get_password 124

    :param credential_id: The credential number (K...) in Phabricator
    :return: The secret value
    """
    _assert_stricly_positive_integer(credential_id)

    zr_command = "zr getcredentials {0}".format(credential_id)
    return __salt__['cmd.shell'](zr_command)


def get_username(credential_id):
    """
    A function to fetch the username associated to a credential
    through Zemke-Rhyne

    CLI Example:

        salt equatower zr.get_username 124

    :param credential_id: The credential number (K...) in Phabricator
    :return: The username
    """
    _assert_stricly_positive_integer(credential_id)

    zr_command = "zr getcredentials {0} username".format(credential_id)
    return __salt__['cmd.shell'](zr_command)
