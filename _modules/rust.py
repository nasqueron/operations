# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Rust module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Provide support for Rust properties
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


from salt.utils.path import which as path_which


def __virtual__():
    """
    Only load if the Rust compiler is available
    """
    return path_which('rustc') is not None,\
        "The Rust execution module cannot be loaded: rustc not installed."


def get_rustc_triplet():
    """
    A function to get a node triplet for Rust toolchains.

    CLI Example:

        salt * rust.get_rustc_triplet
    """

    # Thanks to @semarie for that tip.
    return __salt__['cmd.shell']("rustc -vV | sed -ne 's/^host: //p'")
