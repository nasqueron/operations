#!/usr/bin/env python3

import unittest

import salt_test_case
import rabbitmq_api


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def test_compute_password_hash_with_salt(self):
        self.assertEqual(
            "kI3GCqW5JLMJa4iX1lo7X4D6XbYqlLgxIs30+P6tENUV2POR",
            rabbitmq_api.compute_password_hash_with_salt(0x908DC60A, "test12"),
        )
