#!/usr/bin/env python3

import unittest

import salt_test_case
import convert


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def setUp(self):
        self.initialize_mocks()
        self.instance = convert

    def test_to_flags(self):
        features = ["foo", "bar"]

        self.assertEqual("enable-foo enable-bar", convert.to_flags(features))


if __name__ == "__main__":
    unittest.main()
