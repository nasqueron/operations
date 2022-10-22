#!/usr/bin/env python3

from importlib.machinery import SourceFileLoader
import unittest


salt_test_case = SourceFileLoader("salt_test_case", "salt_test_case.py").load_module()
rabbitmq = SourceFileLoader("rabbitmq", "../_modules/rabbitmq.py").load_module()


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def test_compute_password_hash_with_salt(self):
        self.assertEqual(
            "kI3GCqW5JLMJa4iX1lo7X4D6XbYqlLgxIs30+P6tENUV2POR",
            rabbitmq._compute_password_hash_with_salt(0x908DC60A, "test12"),
        )
