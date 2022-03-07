#!/usr/bin/env python3

from importlib.machinery import SourceFileLoader
import unittest


salt_test_case = SourceFileLoader("salt_test_case", "salt_test_case.py").load_module()
node = SourceFileLoader("node", "../_modules/node.py").load_module()


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def setUp(self):
        self.initialize_mocks()
        self.instance = node

        self.mock_pillar("data/forests.yaml")

        self.mock_grains()
        self.grains["id"] = "egladil"

    def test_get_wwwroot(self):
        self.assertEqual("wwwroot/lothlorien.forest/egladil", node.get_wwwroot())
        self.assertEqual("wwwroot/entwash.node/www", node.get_wwwroot("entwash"))

    def test_has_web_content(self):
        self.assertTrue(node.has_web_content(".ll/carasgaladhon"))
        self.assertFalse(node.has_web_content(".arda/onodlo"))

        self.assertTrue(node.has_web_content(".arda/onodlo", "entwash"))

        self.assertFalse(node.has_web_content("notexisting"))

    def test_filter_by_role(self):
        node_key = self.grains["id"]

        self.assertEqual(["Caras Galadhon"], node.filter_by_role("items_by_role"))

        self.assertEqual(["Onodlo"], node.filter_by_role("items_by_role", "entwash"))

        # No role
        self.pillar["nodes"][node_key]["roles"] = []
        self.assertEqual([], node.filter_by_role("items_by_role"))

        # More than one role
        self.pillar["nodes"][node_key]["roles"] = ["border", "treecity"]
        self.assertEqual(
            ["Caras Galadhon", "Onodlo"], sorted(node.filter_by_role("items_by_role"))
        )

    def test_filter_by_role_with_star(self):
        node_key = self.grains["id"]

        self.assertEqual(
            ["Air", "Caras Galadhon"], node.filter_by_role("items_by_role_with_star")
        )

        self.assertEqual(
            ["Air", "Onodlo"], node.filter_by_role("items_by_role_with_star", "entwash")
        )

        # No role
        self.pillar["nodes"][node_key]["roles"] = []
        self.assertEqual(["Air"], node.filter_by_role("items_by_role_with_star"))

        # More than one role
        self.pillar["nodes"][node_key]["roles"] = ["border", "treecity"]
        self.assertEqual(
            ["Air", "Caras Galadhon", "Onodlo"],
            sorted(node.filter_by_role("items_by_role_with_star")),
        )

    def test_filter_by_name(self):
        self.assertEqual(["Caras Galadhon"], node.filter_by_name("items_by_name"))

        self.assertEqual(
            ["Caras Galadhon"], node.filter_by_name("items_by_name", "egladil")
        )

        self.grains["id"] = "entwash"
        self.assertEqual([], node.filter_by_name("items_by_name"))

    def test_filter_by_name_with_star(self):
        self.assertEqual(
            ["Air", "Caras Galadhon"], node.filter_by_name("items_by_name_with_star")
        )

        self.assertEqual(
            ["Air", "Caras Galadhon"],
            node.filter_by_name("items_by_name_with_star", "egladil"),
        )

        self.grains["id"] = "entwash"
        self.assertEqual(["Air"], node.filter_by_name("items_by_name_with_star"))

    def test_get_ipv6_list(self):
        self.grains["ipv6"] = [
            "::1",
            "2001:470:1f13:ce7:ca5:cade:fab:1e",
            "2001:470:1f12:ce7::2",
        ]

        self.assertEqual(
            "[::1] [2001:470:1f13:ce7:ca5:cade:fab:1e] [2001:470:1f12:ce7::2]",
            node.get_ipv6_list(),
        )


if __name__ == "__main__":
    unittest.main()
