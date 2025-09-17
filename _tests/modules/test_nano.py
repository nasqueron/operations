#!/usr/bin/env python3

import unittest

import salt_test_case
import nano


DATA_DIR = "data/nanorc_dir"
EXPECTED_INCLUDES = [
    "include data/nanorc_dir/bar.nanorc",
    "include data/nanorc_dir/foo.nanorc",
]

EXTRA_SETTINGS = ["set foo bar"]

EXPECTED_FULL_CONFIG = [""] * 2 + EXPECTED_INCLUDES + EXTRA_SETTINGS


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def test_get_rc_contents(self):
        actual_includes = nano._get_rc_content(DATA_DIR)
        self.assertEqual(EXPECTED_INCLUDES, sorted(actual_includes.strip().split("\n")))

    def test_get_rc_contents_full(self):
        actual_includes = nano._get_rc_content(DATA_DIR, extra_settings=EXTRA_SETTINGS)
        self.assertEqual(
            EXPECTED_FULL_CONFIG, sorted(actual_includes.strip().split("\n"))
        )

    def test_get_rc_includes(self):
        self.assertEqual(EXPECTED_INCLUDES, sorted(nano._get_rc_includes(DATA_DIR)))

    def check_rc_up_to_date_when_it_is(self):
        self.assertTrue(
            nano.check_rc_up_to_date(name="data/nanorc_ok", nanorc_dir=DATA_DIR)
        )

    def check_rc_up_to_date_when_it_is_not(self):
        self.assertFalse(
            nano.check_rc_up_to_date(name="data/nanorc_not_ok", nanorc_dir=DATA_DIR)
        )

    def check_rc_up_to_date_when_it_is_does_not_exist(self):
        self.assertFalse(
            nano.check_rc_up_to_date(name="/not/existing", nanorc_dir=DATA_DIR)
        )


if __name__ == "__main__":
    unittest.main()
