#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Tests :: pillar :: paas :: Docker
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Checks for the Docker pillar: schema, coherence
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

from unittest_data_provider import data_provider
import os
import unittest
import yaml

from pillar.schema_helpers import assert_matches_schema

PILLAR_PATH = "../pillar/paas/docker/"
SCHEMA = "paas-docker.schema.json"


class Testinstance(unittest.TestCase):
    def pillar_files():
        sls_files = find_sls_files(PILLAR_PATH)

        return tuple((file,) for file in sls_files)

    # nginx needs a host/app_port pair to spawn a configuration
    @data_provider(pillar_files)
    def test_host_is_paired_with_app_port_option(self, pillar_file):
        with open(pillar_file, "r") as fd:
            self.pillar = yaml.safe_load(fd)

        for service, containers in self.pillar.get("docker_containers", {}).items():
            for instance, container in containers.items():
                if "host" not in container:
                    continue

                entry = ":".join(["docker_containers", pillar_file, service, instance])
                self.assertIn("app_port", container, entry + ": app_port missing")

    @data_provider(pillar_files)
    def test_pillar_matches_schema(self, pillar_file):
        assert_matches_schema(self, pillar_file, SCHEMA)


def find_sls_files(path):
    sls_files = []

    for root, _, files in os.walk(path):
        for filename in files:
            if filename.endswith(".sls"):
                sls_files.append(os.path.join(root, filename))

    return sls_files


if __name__ == "__main__":
    unittest.main()
