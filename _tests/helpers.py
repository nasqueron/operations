#   -------------------------------------------------------------
#   Helper utilities for tests suite
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        0BSD for import_from_path
#                   BSD-2-Clause for load_pillar*
#   Reference:      http://docs.python.org/3/library/importlib.html
#   -------------------------------------------------------------


import importlib.util
import os
import sys
from typing import Dict, List

import yaml


#   -------------------------------------------------------------
#   Import mechanics
#
#   Supersede importlib.machinery.SourceFileLoader load_module use
#   to maintain compatibility with Python 3.12+
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def import_from_path(module_name, file_path):
    file_final_path = "../" + file_path
    spec = importlib.util.spec_from_file_location(module_name, file_final_path)

    module = importlib.util.module_from_spec(spec)
    sys.modules[module_name] = module
    spec.loader.exec_module(module)

    return module


#   -------------------------------------------------------------
#   Pillar helpers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def load_pillar_files(pillar_directory: str) -> List:
    pillar_files = []

    for dir_path, dir_names, file_names in os.walk(pillar_directory):
        files = [
            os.path.join(dir_path, file_name)
            for file_name in file_names
            if file_name.endswith(".sls")
        ]

        pillar_files.extend(files)

    return pillar_files


def load_pillar(file_path: str) -> Dict:
    with open(file_path) as fd:
        return yaml.safe_load(fd)


def load_pillars(directory_path) -> Dict:
    pillar_files = load_pillar_files(directory_path)

    return {file_path: load_pillar(file_path) for file_path in pillar_files}
