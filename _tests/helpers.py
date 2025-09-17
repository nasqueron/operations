#   -------------------------------------------------------------
#   Helper utilities for tests suite
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        0BSD for import_from_path
#   Reference:      http://docs.python.org/3/library/importlib.html
#   -------------------------------------------------------------


import importlib.util
import sys


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
