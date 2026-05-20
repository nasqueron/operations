#!/usr/bin/env python3

import unittest

import salt_test_case
import certificates


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def setUp(self):
        self.initialize_mocks()
        self.instance = certificates

        self.mock_pillar("data/pillar/certificates.yaml")

    def test_get_certificates_options(self):
        expected = {
            "foo.domain.tld": {
                # Default option
                "reload": "nginx -s reload",
            },
            "bar.domain.tld": {
                # Default option
                "reload": "nginx -s reload",
                # Specific option
                "shared_group": "baz",
            },
            "quux.domain.tld": {
                # Specific option
                "reload": "propagate-quux-certificate",
            },
        }

        self.assertEqual(expected, self.instance.get_certificates_options())


if __name__ == "__main__":
    unittest.main()
