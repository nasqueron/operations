#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Create clang-format
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Search for clang-format<version> and alias it
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


from glob import glob
import os
import sys


#   -------------------------------------------------------------
#   Create clang-format alias
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def create_alias(bin_directory):
    candidates = glob(f"{bin_directory}/clang-format*")

    if not candidates:
        return False

    candidate = max(candidates)
    os.symlink(candidate, f"{bin_directory}/clang-format")

    return True


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


if __name__ == "__main__":
    argc = len(sys.argv)

    if argc < 2:
        print(f"Usage: {sys.argv[0]} <bin directory>", file=sys.stderr)
        sys.exit(1)

    create_alias(sys.argv[1])
