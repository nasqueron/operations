#!/usr/bin/env python3

from importlib.machinery import SourceFileLoader
import unittest

salt_test_case = SourceFileLoader("salt_test_case", "salt_test_case.py").load_module()
prometheus = SourceFileLoader("prometheus", "../_modules/prometheus.py").load_module()


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def setUp(self):
        self.initialize_mocks()
        self.instance = prometheus

        self.mock_pillar("data/prometheus.yaml")

        self.mock_salt()
        self.mock_salt_pillar_get()

    def test_resolve_service(self):
        service = {
            "service": "green",
            "port": "9090",
        }

        self.assertEquals("emerald:9090", prometheus._resolve_service(service))

    def test_resolve_service_list(self):
        service = {
            "service": "blue:all",
            "port": "9090",
        }

        expected = [
            "cyan:9090",
            "turquoise:9090",
            "ultramarine:9090",
        ]

        self.assertEquals(expected, prometheus._resolve_service_list(service))

    def test_get_scrape_configs(self):
        expected = self.import_data_from_yaml("data/prometheus_scrape_configs.yml")
        actual = prometheus.get_scrape_configs()

        self.assertEquals(expected, actual)


if __name__ == "__main__":
    unittest.main()
