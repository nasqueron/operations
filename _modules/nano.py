# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Nano execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-02-09
#   Description:    Allow to generate nano configuration
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import subprocess


def _get_rc_includes(nanorc_dir):
    process = subprocess.run(["find", nanorc_dir, "-type", "f"], check=True,
                             stdout=subprocess.PIPE, universal_newlines=True)
    return ["include " + file for file in process.stdout.split()]


def _get_rc_content(nanorc_dir):
    nano_rc_includes = _get_rc_includes(nanorc_dir)

    return "\n".join(nano_rc_includes) + "\n"


def check_rc_up_to_date(name="/etc/nanorc", nanorc_dir="/usr/share/nano"):
    expected_content = _get_rc_content(nanorc_dir)

    try:
        fd = open(name)
    except OSError:
        return False

    actual_content = "".join(fd.readlines())
    fd.close()

    return actual_content == expected_content


def config_autogenerate(name="/etc/nanorc", nanorc_dir="/usr/share/nano"):
    nano_rc_content = _get_rc_content(nanorc_dir)

    fd = open(name, "w")
    fd.write(nano_rc_content)
    fd.close()
