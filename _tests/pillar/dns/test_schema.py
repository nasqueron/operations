#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Tests :: pillar :: DNS against JSON schema
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Checks for DNS pillar coherence
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

import unittest
from unittest_data_provider import data_provider

from pillar.schema_helpers import PILLAR_ROOT, assert_matches_schema, find_sls_files

PILLAR_PATH = PILLAR_ROOT / "dns"
SCHEMA = "dns.schema.json"


class Testinstance(unittest.TestCase):
    @staticmethod
    def provide_pillar_files():
        for pillar_file_path in find_sls_files(PILLAR_PATH):
            yield (pillar_file_path,)

    @data_provider(provide_pillar_files)
    def test_pillar_matches_schema(self, pillar_file_path):
        assert_matches_schema(self, pillar_file_path, SCHEMA)


if __name__ == "__main__":
    unittest.main()
