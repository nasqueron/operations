# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Network execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import re


#   -------------------------------------------------------------
#   CIDR netmask and prefixes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def is_valid_netmask(netmask):
    # "255.255.255.240" → "11111111111111111111111111110000"
    bits = "".join([format(int(octet), "b") for octet in netmask.split(".")])

    # A netmask is valid if the suite of bits:
    #   - starts by contiguous 1, e.g. here 1111111111111111111111111111
    #   - ends by contiguous 0,   e.g. here 0000
    #
    # Also, as 0.0.0.0 is invalid, netmask must starts by 1.
    return re.compile("^1+0*$").match(bits) is not None


def netmask_to_cidr_prefix(netmask):
    """
    Convert a netmask like 255.255.255.240 into a CIDR prefix like 24.

    This can be useful for RHEL network scripts requiring PREFIX information.
    """

    if not is_valid_netmask(netmask):
        raise ValueError("Netmask is invalid.")

    # The CIDR prefix is the count of 1 bits in each octet.
    # e.g. 255.255.255.240 can be split in octets [255, 255, 255, 240],
    # then becomes ['0b11111111', '0b11111111', '0b11111111', '0b11110000'].
    #
    # There is 24 "1" in this expression, that's 24 is our CIDR prefix.
    return sum([bin(int(octet)).count("1") for octet in netmask.split(".")])
