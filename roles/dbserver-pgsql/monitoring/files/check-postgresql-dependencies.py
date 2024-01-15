#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Monitoring :: PostgreSQL :: Dynamic dependencies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Checks if the PostgreSQL port needs to be rebuild
#                   if dependencies have been upgraded.
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import distutils.spawn
import lddcollect
import sys


#   -------------------------------------------------------------
#   Dependencies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_libs_real_paths(process):
    dependencies = lddcollect.lddtree(process)

    return {lib: lib_info["realpath"] for lib, lib_info in dependencies["libs"].items()}


def get_missing_libs(process):
    libs = get_libs_real_paths(process)

    return [lib for lib, path in libs.items() if path is None]


#   -------------------------------------------------------------
#   PostgreSQL locator
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def find_postgres():
    return distutils.spawn.find_executable("postgres")


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run():
    process = find_postgres()
    if process is None:
        print("UNKNOWN: can't find expected postgres process")
        sys.exit(3)

    missing_libs = get_missing_libs(process)
    if not missing_libs:
        print("OK")
        sys.exit(0)

    libs = " / ".join(missing_libs)
    print(
        f"ERROR: {libs} are missing, PostgreSQL port MUST be rebuilt as soon as possible."
    )
    sys.exit(2)


if __name__ == "__main__":
    run()
