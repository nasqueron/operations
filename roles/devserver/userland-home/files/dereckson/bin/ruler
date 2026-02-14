#!/usr/bin/env tclsh8.6

set DEFAULT_LEN 80

proc spaces_for_dozen {n} {
    string repeat " " [expr 10 - [string length $n]]
}

proc ruler {len} {
    set i 0
    set tens [expr $len / 10]

    set line_units ""
    set line_tens ""

    # First, build our ruler string by appending groups of 10 digits
    while {$i < $tens} {
        incr i

        append line_units "1234567890"

        append line_tens [spaces_for_dozen $i]
        append line_tens $i
    }

    # Then, adds units for our last group if needed
    set remaining_units [expr $len % 10]
    for {set i 1} {$i <= $remaining_units} {incr i} {
        append line_units $i
    }

    # Prints the lines
    join [list $line_units $line_tens] "\n"
}

#
# Parses arguments
#

proc usage {} {
    set command [file tail [info script]]

    puts stderr "Usage: $command \[len\]"
    puts stderr "Print a ruler of specified length."
}

if {$argc == 0} {
    set len $DEFAULT_LEN
} elseif {$argc == 1} {
    set len $argv

    if {![string is integer $len]} {
        usage
        exit 2
    }
} {
    usage
    exit 1
}

#
# Procedural part
#

puts [ruler $len]
