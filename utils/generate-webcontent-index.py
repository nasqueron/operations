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


pillar_file = "pillar/webserver/sites.sls"
file_to_update = "roles/webserver-content/init.sls"


#   -------------------------------------------------------------
#   Update code
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def do_update(pillar_file, file_to_update):
    print_header(file_to_update)
    print("\ninclude:")
    for site in get_sites(pillar_file):
        print("  - {}".format(site))


def get_pillar_entry(pillar_file, key):
    with open(pillar_file) as fd:
        pillar = yaml.load(fd.read())
    return pillar[key]


def get_sites(pillar_file):
    sites = get_pillar_entry(pillar_file, 'web_content_sls')
    return sorted([site for sublist in
                   [sites[role] for role in sites]
                   for site in sublist])


def print_header(file_to_update):
    with open(file_to_update) as fd:
        for line in fd:
            if not line.startswith("#"):
                break
            print(line, end="")


#   -------------------------------------------------------------
#   Run task
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


if __name__ == "__main__":
    do_update(pillar_file, file_to_update)
