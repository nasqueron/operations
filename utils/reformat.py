#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Salt — Reformat Salt states and source code files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-02-26
#   License:        BSD-2-Clause
#   Description:    This script detects multi-lines patterns
#                   and rewrite them to apply the new style.
#
#                   Before: \n BLOCK_START [...] BLOCK_START
#                   After:  \n BLOCK_START [...] BLOCK_END
#   -------------------------------------------------------------

import sys

BLOCK_START = "#   -------------------------------------------------------------\n"
BLOCK_END = "#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n"


def usage():
    print(f"usage: {sys.argv[0]} <file to reformat>", file=sys.stderr)


class Reformater:
    def __init__(self, file):
        self.file = file
        self.pattern_detection_counter = 0

    def reformat_inline(self):
        buffer = []
        with open(self.file, "r+") as fd:
            for line in fd:
                buffer.append(self.reformat_line(line))

            fd.seek(0)
            fd.truncate()
            fd.writelines(buffer)

    def reformat_line(self, line):
        if self.pattern_detection_counter == 0 and line == "\n":
            self.pattern_detection_counter += 1
        elif self.pattern_detection_counter == 1 and line == BLOCK_START:
            self.pattern_detection_counter += 1
        elif self.pattern_detection_counter == 2:
            if line == BLOCK_END:
                # We're probably in an header block or a correct one, so skip
                self.pattern_detection_counter = 0
            elif line == BLOCK_START:
                # We've got a winner
                self.pattern_detection_counter = 0
                return BLOCK_END
            elif not line.startswith("#"):
                # Let's go on, it's a multiline comments block
                self.pattern_detection_counter = 0
        else:
            self.pattern_detection_counter = 0

        return line


if __name__ == "__main__":
    if len(sys.argv) < 2:
        usage()
        sys.exit(1)

    file_to_reformat = sys.argv[1]
    Reformater(file_to_reformat).reformat_inline()
