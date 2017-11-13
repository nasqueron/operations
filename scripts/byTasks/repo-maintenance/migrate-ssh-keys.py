#!/usr/bin/env python3

#   -------------------------------------------------------------
#   rOPS — migrate SSH keys from file to Salt state
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-09
#   Description:    Read a dictionary, and for each key, find in
#                   a specified folder a data file. Add data from
#                   this file to the dictionary. Output in YAML.
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Table of contents
#   -------------------------------------------------------------
#
#   :: Configuration
#   :: YAML style
#   :: Update code
#   :: Run task
#
#   -------------------------------------------------------------


import os
import yaml


#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# Where is located the dictionary to update?
state_file = 'pillar/core/users.sls'
state_key = 'shellusers'

# Where are located the data fileS?
data_path = 'roles/shellserver/users/files/ssh_keys/'

# What property should get the data and be added if missing in the dict?
state_data_property = 'ssh_keys'


#   -------------------------------------------------------------
#   YAML style
#
#   Allows to dump with indented lists
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


class SaltStyleDumper(yaml.Dumper):

    def increase_indent(self, flow=False, indentless=False):
        return super(SaltStyleDumper, self).increase_indent(flow, False)


#   -------------------------------------------------------------
#   Update code
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def do_update():
    state = read_state()
    update_state(state)
    print(dump_state(state))


def read_state():
    fd = open(state_file, "r")
    states = yaml.load(fd.read())
    fd.close()

    return states[state_key]


def update_state(state):
    for key in state:
        if state_data_property not in state[key]:
            state[key][state_data_property] = read_data(key)


def read_data(key):
    path = data_path + key

    if not os.path.exists(path):
        return []

    return [line.strip() for line in open(path, "r") if is_value_line(line)]


def is_value_line(line):
    if line.startswith("#"):
        return False

    if line.strip() == '':
        return False

    return True


def dump_state(state):
    return yaml.dump({state_key: state},
                     default_flow_style=False,
                     Dumper=SaltStyleDumper, width=1000)


#   -------------------------------------------------------------
#   Run task
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


do_update()
