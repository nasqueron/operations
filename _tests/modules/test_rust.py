#!/usr/bin/env python3

import unittest

from salt.modules import cmdmod

import salt_test_case
import rust


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def setUp(self):
        self.initialize_mocks()
        self.instance = rust

        self.mock_salt()
        self.salt["cmd.shell"] = cmdmod.shell

    def test_get_rustc_triplet(self):
        triplet = rust.get_rustc_triplet()

        self.assertTrue(len(triplet.split("-")) > 2)


if __name__ == "__main__":
    unittest.main()
