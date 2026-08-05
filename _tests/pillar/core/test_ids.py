#!/usr/bin/env python3

import unittest
import yaml

PILLAR_FILE = "../pillar/core/ids.sls"


class TestIds(unittest.TestCase):
    def setUp(self):
        with open(PILLAR_FILE, "r") as fd:
            self.pillar = yaml.safe_load(fd)

    def test_ids_are_integers(self):
        errors = []

        for section in ("uids", "gids"):
            for name, identifier in self.pillar[section].items():
                if not isinstance(identifier, int):
                    errors.append(f"{section}:{name} isn't an integer")

        self.assertEqual([], errors)

    def test_ids_are_unique_in_each_section(self):
        errors = []

        for section in ("uids", "gids"):
            ids = list(self.pillar[section].values())
            duplicates = {identifier for identifier in ids if ids.count(identifier) > 1}
            if duplicates:
                errors.append(f"{section} has duplicate IDs: {duplicates}")

        self.assertEqual([], errors)


if __name__ == "__main__":
    unittest.main()
