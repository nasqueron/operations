#   -------------------------------------------------------------
#   Salt — Python execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    As grains can now describe the Python interpreter
#                   installed by SaltStack, this module allows querying
#                   information about the global Python.
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import os
import subprocess


def get_interpreter() -> str:
    if __grains__["os"] == "FreeBSD":
        return "/usr/local/bin/python3"
    else:
        return "/usr/bin/python3"


def get_version() -> str:
    result = subprocess.run([get_interpreter(), "--version"], capture_output=True)
    full_version = result.stdout.decode().strip()

    # "Python 3.13.7" -> "3.13"
    return ".".join(full_version.split()[1].split(".")[0:2])


def get_site_packages_directory() -> str:
    python_version = get_version()

    if __grains__["os"] == "FreeBSD":
        return f"/usr/local/lib/python{python_version}/site-packages"
    else:
        return f"/usr/lib/python{python_version}/site-packages"


def is_package_installed(package_name: str) -> bool:
    package_directory = os.path.join(get_site_packages_directory(), package_name)

    return os.path.exists(package_directory)
