#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Tests for dbserver pillar, PostgreSQL flavour
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Checks for PostgreSQL pillar coherence
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import unittest
from unittest_data_provider import data_provider

from helpers import load_pillars


#   -------------------------------------------------------------
#   Connection keys
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


MANDATORY_CONNECTION_KEYS = [
    "db",
    "user",
    "ips",
]

OPTIONAL_CONNECTION_KEYS = [
    "method",
]

ALL_CONNECTION_KEYS = MANDATORY_CONNECTION_KEYS + OPTIONAL_CONNECTION_KEYS


#   -------------------------------------------------------------
#   Tests
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


pillars = load_pillars("../pillar/dbserver/")


class Testinstance(unittest.TestCase):
    @staticmethod
    def provide_pillars():
        for file_path, pillar in pillars.items():
            if "dbserver_postgresql" not in pillar:
                continue

            yield file_path, pillar["dbserver_postgresql"]

    @data_provider(provide_pillars)
    def test_connections(self, pillar_file_path, pillar):
        for connection in pillar["connections"]:
            for key in MANDATORY_CONNECTION_KEYS:
                self.assertIn(
                    key, connection, f"Mandatory key missing in {pillar_file_path}"
                )

            for key in connection:
                self.assertIn(
                    key,
                    ALL_CONNECTION_KEYS,
                    f"Unknown connection parameter in {pillar_file_path}",
                )

            self.assertIn(
                "/",
                connection["ips"],
                f"Connection IP range should be in CIDR notation in {pillar_file_path}.",
            )
