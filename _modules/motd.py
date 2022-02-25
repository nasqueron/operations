# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — MOTD execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Allow to generate MOTD
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


def get_path():
    os = __grains__["os_family"]

    if os == "Debian":
        return "/etc/motd.tail"

    if os == "FreeBSD" and __grains__["osmajorrelease"] >= 13:
        return "/etc/motd.template"

    return "/etc/motd"
