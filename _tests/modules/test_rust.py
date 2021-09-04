from importlib.machinery import SourceFileLoader
import unittest


salt_test_case = SourceFileLoader('salt_test_case', "salt_test_case.py").load_module()
rust = SourceFileLoader('rust', "../_modules/rust.py").load_module()


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):

    def test_get_rustc_triplet(self):
        triplet = rust.get_rustc_triplet()

        self.assertTrue(len(triplet.split("-")) > 2)
