#!/usr/bin/env python3

#   -------------------------------------------------------------
#   rOPS — compile a #!py .sls file and dump the result in YAML
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-17
#   Description:    Read the web_content_sls pillar entry
#                   and regenerate the webserver-content include.
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import os
import subprocess
import sys
import yaml


#   -------------------------------------------------------------
#   Pillar helper
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_pillar_files(pillar_directory):
    pillar_files = []

    for dir_path, dir_names, file_names in os.walk(pillar_directory):
        files = [
            os.path.join(dir_path, file_name)
            for file_name in file_names
            if file_name.endswith(".sls")
        ]

        pillar_files.extend(files)

    return pillar_files


def load_pillar(pillar_directory):
    pillar = {}

    for pillar_file in get_pillar_files(pillar_directory):
        data = yaml.safe_load(open(pillar_file, "r"))
        pillar.update(data)

    return pillar


#   -------------------------------------------------------------
#   Grains helper
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def system(args):
    result = subprocess.run(args, stdout=subprocess.PIPE)
    return result.stdout.decode("utf-8").strip()


#   -------------------------------------------------------------
#   Source code helper
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run_shim():
    return "\n\nif __name__ == '__main__':\n\tprint(yaml.dump(run(), default_flow_style=False))"


def assemble_source_code(filename):
    with open(filename, "r") as fd:
        source_code = fd.read()

    return source_code + run_shim()


#   -------------------------------------------------------------
#   Run task
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


if __name__ == "__main__":
    argc = len(sys.argv)

    if argc < 2:
        print("Usage: dump-py-state.py <sls file>", file=sys.stderr)
        exit(1)

    sls_file = sys.argv[1]

    try:
        source_code_to_dump = assemble_source_code(sls_file)
    except OSError as ex:
        print(ex, file=sys.stderr)
        exit(ex.errno)

    __pillar__ = load_pillar("pillar")
    __grains__ = {"os": system(["uname", "-o"])}

    exec(source_code_to_dump)
