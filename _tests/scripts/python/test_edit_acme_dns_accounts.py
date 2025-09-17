#!/usr/bin/env python3


import os
import unittest

from helpers import import_from_path


script_path = "roles/core/certificates/files/edit-acme-dns-accounts.py"
script = import_from_path("script", script_path)


os.environ["ACME_ACCOUNTS"] = "/path/to/acmedns.json"


class TestInstance(unittest.TestCase):
    def setUp(self):
        self.testAccounts = script.AcmeAccounts("/dev/null")
        pass

    def test_read_path_from_environment(self):
        self.assertEqual("/path/to/acmedns.json", script.get_acme_accounts_path())

    def test_accounts_are_empty_on_init(self):
        self.assertEqual({}, self.testAccounts.accounts)

    def test_add(self):
        self.testAccounts.add("foo.tld", {})
        self.assertEqual(1, len(self.testAccounts.accounts))
        self.assertIn("foo.tld", self.testAccounts.accounts)

    def test_remove_existing(self):
        self.testAccounts.add("foo.tld", {})
        self.assertTrue(self.testAccounts.remove("foo.tld"))
        self.assertEqual(0, len(self.testAccounts.accounts))

    def test_remove_non_existing(self):
        self.assertFalse(self.testAccounts.remove("not-existing.tld"))

    def test_merge(self):
        accounts_to_merge = script.AcmeAccounts("/dev/null").add("bar.tld", {})

        self.testAccounts.add("foo.tld", {}).merge_with(accounts_to_merge)

        self.assertEqual(2, len(self.testAccounts.accounts))


if __name__ == "__main__":
    unittest.main()
