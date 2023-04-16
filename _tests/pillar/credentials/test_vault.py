#!/usr/bin/env python3

from glob import glob
import os
import unittest
import yaml


PILLAR_FILE = "../pillar/credentials/vault.sls"


class Testinstance(unittest.TestCase):
    def setUp(self):
        with open(PILLAR_FILE, "r") as fd:
            self.pillar = yaml.safe_load(fd)

    def test_policies_files(self):
        in_pillar = self.pillar.get("vault_policies", [])

        files = glob("../roles/vault/policies/files/*.hcl")
        in_role = [os.path.basename(file).split(".")[0] for file in files]

        in_pillar.sort()
        in_role.sort()
        self.assertEqual(
            in_pillar,
            in_role,
            "Pillar vault_policies and policies files available should match.",
        )


if __name__ == "__main__":
    unittest.main()
