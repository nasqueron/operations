#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Create from template
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Creates file from template
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import os
import subprocess
import sys

import yaml


ROOT_TEMPLATE_DIR = "_resources/templates"


#   -------------------------------------------------------------
#   Configuration and directories helpers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run_command(command):
    process = subprocess.run(command, capture_output=True, text=True)
    return process.stdout.strip()


def get_root_dir():
    return run_command(["git", "rev-parse", "--show-toplevel"])


def get_root_template_dir():
    return os.path.join(get_root_dir(), ROOT_TEMPLATE_DIR)


def load_config():
    with open(get_root_template_dir() + "/templates.yml") as fd:
        return yaml.safe_load(fd)


#   -------------------------------------------------------------
#   Template
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


class OpsTemplate:
    def __init__(self, template_dir, target_dir, template_config, values):
        self.template_dir = template_dir
        self.target_dir = target_dir
        self.root_dir = get_root_dir()
        self.variables = dict(zip(template_config["variables"], values))

    def get_relative_path(self, filename):
        return os.path.relpath(filename, self.root_dir)

    def write_file(self, source, target):
        with open(source, "r") as source_fd, open(target, "w") as target_fd:
            for line in source_fd:
                for key, value in self.variables.items():
                    line = line.replace(f"%%{key}%%", value)
                line = line.replace("%%cwd%%", self.get_relative_path(self.target_dir))
                line = line.replace("%%path%%", self.get_relative_path(target))

                target_fd.write(line)

    def resolve_target_name(self, target_path):
        for key, value in self.variables.items():
            target_path = target_path.replace(f"__{key}__", value)

        return target_path

    def apply(self):
        if not os.path.exists(self.target_dir):
            os.makedirs(self.target_dir)

        for root, dirs, files in os.walk(self.template_dir):
            relative_path = os.path.relpath(root, self.template_dir)
            if relative_path == ".":
                target_dir = self.target_dir
            else:
                target_dir = os.path.join(self.target_dir, relative_path)
                os.makedirs(target_dir, exist_ok=True)

            for file in files:
                source_file = os.path.join(root, file)
                target_file = os.path.join(target_dir, file)
                target_file = self.resolve_target_name(target_file)

                self.write_file(source_file, target_file)


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run(template_name):
    config = load_config()

    if template_name in config["aliases"]:
        template_name = config["aliases"][template_name]

    if template_name not in config["templates"]:
        print(
            f"Unknown template: {template_name}, check templates.yml", file=sys.stderr
        )
        sys.exit(2)

    template_config = config["templates"][template_name]
    args = sys.argv[2:]

    expected_args_count = len(template_config["variables"])
    if expected_args_count > len(args):
        print("Expected template arguments missing.", file=sys.stderr)

        expected_args = [f"<{arg}>" for arg in template_config["variables"]]
        expected_args = " ".join(expected_args)
        print(f"Usage: {sys.argv[0]} {sys.argv[1]} {expected_args}", file=sys.stderr)

        sys.exit(4)

    template = OpsTemplate(
        os.path.join(get_root_template_dir(), template_name),
        os.getcwd(),
        template_config,
        args,
    )
    template.apply()


if __name__ == "__main__":
    argc = len(sys.argv)

    if argc < 2:
        print(f"Usage: {sys.argv[0]} <template name>", file=sys.stderr)
        sys.exit(1)

    run(sys.argv[1])
