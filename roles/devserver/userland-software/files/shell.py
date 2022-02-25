#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Operations utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Author:         Sébastien Santoro aka Dereckson
#   Created:        2018-03-08
#   License:        BSD-2-Clause
#   Source file:    roles/devserver/userland-software/files/shell.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

from collections import deque

import os
import re
import subprocess
import sys
import yaml


#   -------------------------------------------------------------
#   Configuration file locator
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_candidates_configuration_directories():
    candidates = []

    if "HOME" in os.environ:
        candidates.append(os.environ["HOME"])

    candidates.append("/usr/local/etc")
    candidates.append("/etc")

    return candidates


def get_candidates_configuration_files():
    return [
        directory + "/.shell.yml"
        for directory in get_candidates_configuration_directories()
    ]


def find_configuration_file():
    for candidate in get_candidates_configuration_files():
        if os.path.isfile(candidate):
            return candidate


#   -------------------------------------------------------------
#   Configuration file parser
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def parse_configuration_file(filename):
    configuration_file = open(filename, "r")
    configuration = yaml.safe_load(configuration_file)
    configuration_file.close()

    return configuration


#   -------------------------------------------------------------
#   Server connection
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


class ServerConnection:
    """Represents a server connection with a command to run."""

    config = {}
    args = []

    def __init__(self, config, args):
        self.config = config
        self.args = deque(args)

    def clear_args(self):
        self.args = deque([])

    def pop_all_args(self):
        to_return = list(self.args)
        self.clear_args()
        return to_return

    def get_default_command(self):
        return ["ssh"]

    def get_alias(self, alias_name):
        return self.get_config_section("aliases", alias_name)

    def get_handler(self, handler_name):
        return self.get_config_section("handlers", handler_name)

    def get_config_section(self, section, key):
        if section in self.config:
            if key in self.config[section]:
                return self.config[section][key]

    def parse_alias(self, alias):
        if "args" in alias:
            alias["args"].reverse()
            self.args.extendleft(alias["args"])

        if "handler" in alias:
            handler = self.config["handlers"][alias["handler"]]
            return self.parse_handler(handler)

        if "command" in alias:
            return self.parse_command(alias["command"])

        raise ValueError("Unable to parse alias")

    def parse_handler(self, handler):
        command = self.get_default_command()

        if "interactive" in handler and handler["interactive"]:
            command.append("-t")

        command.append(handler["server"])
        command.extend(self.parse_command(handler["command"]))
        command.extend(self.args)

        return command

    def parse_variable_fragment(self, variable):
        # {{%s-|bash}} means %s-, with bash as default value if we don't
        # have any more argument to substitute
        matches = re.search("(.*)\|(.*)", variable)
        if matches:
            if not self.args:
                return [matches.group(2)]

            cleaned_fragment = matches.group(1)
            return self.parse_variable_fragment(cleaned_fragment)

        # Substitute with one argument
        if variable == "%s":
            return [self.args.popleft()]

        # Substitute with all arguments
        if variable == "%s-":
            return self.pop_all_args()

        raise ValueError("Can't parse " + variable)

    def parse_fragment(self, fragment):
        # If the fragment is {{something}}, this is a variable to substitute.
        matches = re.search("{{(.*)}}", fragment)
        if matches:
            return self.parse_variable_fragment(matches.group(1))

        return [fragment]

    def parse_command(self, command):
        parsed_command = []

        fragments = [self.parse_fragment(fragment) for fragment in command]
        for fragment in fragments:
            parsed_command.extend(fragment)

        return parsed_command

    def parse_connection(self):
        if not self.args:
            raise ValueError("Expected arguments missing")

        target = self.args.popleft()

        # Is it an alias?
        alias = self.get_alias(target)
        if alias is not None:
            return self.parse_alias(alias)

        # Is it an handler?
        handler = self.get_handler(target)
        if handler is not None:
            return self.parse_handler(handler)

        raise ValueError(target + ": No such target")


#   -------------------------------------------------------------
#   Runner code
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_program_name():
    return os.path.basename(sys.argv[0])


def is_debug_mode_enabled():
    return "DEBUG" in os.environ


def print_error(err):
    print("{}: {}".format(get_program_name(), err), file=sys.stderr)


def get_configuration():
    configuration_file = find_configuration_file()

    if configuration_file is None:
        print_error("No shell configuration file found")
        exit(2)

    return parse_configuration_file(configuration_file)


def usage():
    print("usage: shell target [subtarget] [command ...]", file=sys.stderr)


def main():
    if len(sys.argv) < 2:
        usage()
        exit(1)

    config = get_configuration()
    connection = ServerConnection(config, sys.argv[1:])
    try:
        subprocess_args = connection.parse_connection()
    except IndexError:
        print_error("Required argument is missing.")
        exit(8)
    except ValueError as e:
        print_error(e)
        exit(4)

    if is_debug_mode_enabled():
        print(subprocess_args, file=sys.stderr)

    subprocess.run(subprocess_args)


if __name__ == "__main__":
    main()
