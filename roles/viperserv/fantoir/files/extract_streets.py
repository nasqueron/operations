#!/usr/bin/env python3

#   -------------------------------------------------------------
#   FANTOIR — Extract streets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-14
#   License:        Trivial work, not eligible to copyright
#   Data license:   FANTOIR is licensed under Licence Ouverte
#   -------------------------------------------------------------

import sys


def extract_streets(filename_source, filename_out):
    with open(filename_out, 'w') as output,\
         open(filename_source, 'r') as input:
        for line in input:
            # Streets and other « voies » are the record where
            # the 109th position (« type de voie ») is 1.
            try:
                if line[108] == "1":
                    output.write(line)
            except IndexError:
                pass


if __name__ == "__main__":
    argc = len(sys.argv)
    if (argc != 3):
        print("Usage: {} <FANTOIR filename> <street filename>"
              .format(sys.argv[0]),
              file=sys.stderr)
        sys.exit(1)

    extract_streets(sys.argv[1], sys.argv[2])
