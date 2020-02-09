from importlib.machinery import SourceFileLoader
import unittest


salt_test_case = SourceFileLoader(
    'salt_test_case', "salt_test_case.py").load_module()
nano = SourceFileLoader('nano', "../_modules/nano.py").load_module()


DATA_DIR = "data/nanorc_dir"
EXPECTED_INCLUDES = [
    'include data/nanorc_dir/bar.nanorc',
    'include data/nanorc_dir/foo.nanorc',
]


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):

    def test_get_rc_contents(self):
        actual_includes = nano._get_rc_content(DATA_DIR)
        self.assertEqual(EXPECTED_INCLUDES,
                         sorted(actual_includes.strip().split("\n")))

    def test_get_rc_includes(self):
        self.assertEqual(EXPECTED_INCLUDES,
                         sorted(nano._get_rc_includes(DATA_DIR)))

    def check_rc_up_to_date_when_it_is(self):
        self.assertTrue(nano.check_rc_up_to_date(name="data/nanorc_ok",
                                                 nanorc_dir=DATA_DIR))

    def check_rc_up_to_date_when_it_is_not(self):
        self.assertFalse(nano.check_rc_up_to_date(name="data/nanorc_not_ok",
                                                  nanorc_dir=DATA_DIR))

    def check_rc_up_to_date_when_it_is_does_not_exist(self):
        self.assertFalse(nano.check_rc_up_to_date(name="/not/existing",
                                                  nanorc_dir=DATA_DIR))


if __name__ == '__main__':
    unittest.main()
