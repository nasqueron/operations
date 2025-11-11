#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Tests for roles/dns files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Checks for DNS zones
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import os
import subprocess
import sys
import tempfile
from typing import Dict

from jinja2 import Environment, FileSystemLoader
import unittest
from unittest_data_provider import data_provider

from helpers import load_pillars


#   -------------------------------------------------------------
#   Does zone file exist?
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


ZONE_FILES_DIR = "../roles/dns/knot/files/zones/"


def get_zone_file_path(zone_name: str) -> str:
    return ZONE_FILES_DIR + zone_name + ".zone"


def is_existing_zone_file(zone_name: str) -> bool:
    zone_file_path = get_zone_file_path(zone_name)

    return os.path.exists(zone_file_path)


#   -------------------------------------------------------------
#   Jinja template
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def build_context(pillar: str) -> Dict:
    return {
        # To sync with context from knotdns_file_... from roles/dns/knot/config.sls
        "identity": pillar["dns_identity"],
        "vars": pillar.get("dns_zone_variables", {}),
    }


def resolve_zone_template(pillar: Dict, zone_name: str) -> str:
    zone_path = get_zone_file_path(zone_name).replace("../", "")

    engine = Environment(loader=FileSystemLoader(".."))
    template = engine.get_template(zone_path)
    context = build_context(pillar)

    return template.render(context)


#   -------------------------------------------------------------
#   Call Knot utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def check_zone(file_content: str) -> bool:
    """Validate zone content with kzonecheck"""
    with tempfile.NamedTemporaryFile(mode="w", delete=False) as tmp_fd:
        tmp_fd.write(file_content)

    try:
        result = subprocess.run(
            ["kzonecheck", tmp_fd.name], capture_output=True, text=True
        )

        if result.returncode == 0:
            return True

        print(result.stdout, file=sys.stderr)
        print(result.stderr, file=sys.stderr)
        return False
    finally:
        os.remove(tmp_fd.name)


#   -------------------------------------------------------------
#   Tests
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


pillars = load_pillars("../pillar/dns/")


class Testinstance(unittest.TestCase):
    @staticmethod
    def provide_pillars():
        for file_path, pillar in pillars.items():
            yield (file_path, pillar)

    @data_provider(provide_pillars)
    def test_existing_zone_files(self, pillar_file_path, pillar):
        for zone in pillar.get("dns_zones", []):
            self.assertTrue(
                is_existing_zone_file(zone), f"Missing zone file for {zone}"
            )

    @data_provider(provide_pillars)
    def test_mandatory_fields(self, pillar_file_path, pillar):
        self.assertIn(
            "dns_identity", pillar, "Mandatory key, it should match the DNS server name"
        )

    @data_provider(provide_pillars)
    def test_zone_content(self, pillar_file_path, pillar):
        for zone in pillar.get("dns_zones", []):
            zone_content = resolve_zone_template(pillar, zone)
            zone_path = get_zone_file_path(zone)

            result = check_zone(zone_content)
            self.assertTrue(
                result, f"Zone for {zone} doesn't pass Knot checks. Edit {zone_path}"
            )


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


if __name__ == "__main__":
    unittest.main()
