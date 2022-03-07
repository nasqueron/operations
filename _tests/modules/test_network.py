#!/usr/bin/env python3

from importlib.machinery import SourceFileLoader
from unittest_data_provider import data_provider
import unittest


salt_test_case = SourceFileLoader("salt_test_case", "salt_test_case.py").load_module()
network = SourceFileLoader("network", "../_modules/network_utils.py").load_module()


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    cidr_prefixes = lambda: (
        ("255.255.255.255", 32),
        ("255.255.255.254", 31),
        ("255.255.255.252", 30),
        ("255.255.255.240", 28),
        ("255.255.255.224", 27),
        ("255.255.255.0", 24),
        ("255.252.0.0", 14),
    )

    valid_netmasks = lambda: (
        ("255.255.255.255",),
        ("255.255.255.254",),
        ("255.255.255.252",),
        ("255.255.255.240",),
    )

    invalid_netmasks = lambda: (
        # In binary, it's not a suite of 1 then a suite of 0
        ("255.255.255.209",),

        # By definition, netmask MUST be strictly greater than 0
        ("0.0.0.0",),
    )

    @data_provider(cidr_prefixes)
    def test_netmask_to_cidr_prefix(self, netmask, expected_prefix):
        actual_prefix = network.netmask_to_cidr_prefix(netmask)

        self.assertTrue(actual_prefix == expected_prefix)

    @data_provider(valid_netmasks)
    def test_is_valid_netmask(self, netmask):
        self.assertTrue(network.is_valid_netmask(netmask))

    @data_provider(invalid_netmasks)
    def test_is_valid_netmask_when_it_is_not(self, netmask):
        self.assertFalse(network.is_valid_netmask(netmask))


if __name__ == "__main__":
    unittest.main()
