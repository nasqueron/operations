#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Monitoring :: PostgreSQL :: XML support
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Checks if the PostgreSQL process has XML support
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import distutils.spawn
import lddcollect
import sys


#   -------------------------------------------------------------
#   Dependencies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def has_lib(process, needed_lib):
    dependencies = lddcollect.lddtree(process)

    return any(lib.startswith(needed_lib) for lib in dependencies["needed"])


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

    is_built_against_libxml = has_lib(process, "libxml2.so")
    if is_built_against_libxml:
        print("OK")
        sys.exit(0)

    print(
        "ERROR: PostgreSQL has no XML support through libxml2, PostgreSQL port MUST be rebuilt as soon as possible."
    )
    sys.exit(2)


if __name__ == "__main__":
    run()
