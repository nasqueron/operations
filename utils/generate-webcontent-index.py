#!/usr/bin/env python3

#   -------------------------------------------------------------
#   rOPS — regenerate roles/webserver-content/init.sls
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-24
#   Description:    Read the web_content_sls pillar entry
#                   and regenerate the webserver-content include.
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import yaml


#   -------------------------------------------------------------
#   Table of contents
#   -------------------------------------------------------------
#
#   :: Configuration
#   :: Update code
#   :: Run task
#
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


config = {
    "header": "_resources/headers/webserver-content-init",
    "pillar": "pillar/webserver/sites.sls",
    "states": "roles/webserver-content/init.sls",
}


#   -------------------------------------------------------------
#   Update code
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def do_update(header_file, pillar_file, file_to_update):
    print_file(header_file)

    print("\ninclude:")
    for site in get_sites(pillar_file):
        print("  - {}".format(site))
    print("")
    print("  - ._generic")


def get_pillar_entry(pillar_file, key):
    with open(pillar_file) as fd:
        pillar = yaml.safe_load(fd.read())
    return pillar[key]


def get_sites(pillar_file):
    sites = get_pillar_entry(pillar_file, "web_content_sls")
    return sorted(set(
        [site for sublist in [sites[role] for role in sites] for site in sublist]
    ))


def print_file(file_path):
    with open(file_path) as fd:
        for line in fd:
            if not line.startswith("#"):
                break
            print(line, end="")

#   -------------------------------------------------------------
#   Run task
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


if __name__ == "__main__":
    do_update(config["header"], config["pillar"], config["states"])
