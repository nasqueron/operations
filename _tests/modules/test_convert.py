#!/usr/bin/env python3

from importlib.machinery import SourceFileLoader
import unittest

salt_test_case = SourceFileLoader("salt_test_case", "salt_test_case.py").load_module()
convert = SourceFileLoader("rust", "../_modules/convert.py").load_module()


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def setUp(self):
        self.initialize_mocks()
        self.instance = convert

    def test_to_flags(self):
        features = ["foo", "bar"]

        self.assertEqual("enable-foo enable-bar", convert.to_flags(features))


if __name__ == "__main__":
    unittest.main()
