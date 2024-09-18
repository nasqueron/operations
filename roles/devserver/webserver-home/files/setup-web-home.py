#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Setup web home
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Create folder and symlink for public_html
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import os
import shutil
import sys


#   -------------------------------------------------------------
#   Web setup
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def is_clean(username):
    return not os.path.exists(f"/var/home-wwwroot/{username}") and not os.path.exists(
        f"/home/{username}/public_html"
    )


def is_valid_setup(username):
    return (
        os.path.exists(f"/var/home-wwwroot/{username}")
        and not os.path.islink(f"/var/home-wwwroot/{username}")
        and os.path.islink(f"/home/{username}/public_html")
        and os.readlink(f"/home/{username}/public_html")
        == f"/var/home-wwwroot/{username}"
    )


def setup(username):
    os.mkdir(f"/var/home-wwwroot/{username}", mode=0o755)
    shutil.chown(f"/var/home-wwwroot/{username}", user=username, group="web")
    os.symlink(f"/var/home-wwwroot/{username}", f"/home/{username}/public_html")


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run(username):
    if is_valid_setup(username):
        print("Setup is already done and looks correct.", file=sys.stderr)
        sys.exit(4)

    if not is_clean(username):
        print(
            "Directories exist but aren't correct, check them manually.",
            file=sys.stderr,
        )
        sys.exit(2)

    try:
        setup(username)
    except OSError as e:
        print(e, file=sys.stderr)
        sys.exit(8)


if __name__ == "__main__":
    argc = len(sys.argv)

    if argc < 2:
        print(f"Usage: {sys.argv[0]} <username>", file=sys.stderr)
        sys.exit(1)

    run(sys.argv[1])
