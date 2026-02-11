#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Convert CIDR ranges into map for ngx_http_geo_module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import sys


#   -------------------------------------------------------------
#   Formatter for ngx_http_geo_module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_geo_entry(line):
    line = line.strip()

    if line == "":
        return line
    elif line.startswith("#"):
        return "    " + line

    return f"    {line} 1;"


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run(ranges_path):
    print("geo $range {")
    print("    default 0;")
    print()

    with open(ranges_path) as fd:
        for line in fd:
            print(get_geo_entry(line))

    print("}")


if __name__ == "__main__":
    argc = len(sys.argv)

    if argc < 2:
        print(f"Usage: {sys.argv[0]} <ranges file>", file=sys.stderr)
        sys.exit(1)

    run(sys.argv[1])
