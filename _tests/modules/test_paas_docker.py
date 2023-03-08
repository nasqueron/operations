#!/usr/bin/env python3

from importlib.machinery import SourceFileLoader
import unittest

salt_test_case = SourceFileLoader("salt_test_case", "salt_test_case.py").load_module()
docker = SourceFileLoader("docker", "../_modules/paas_docker.py").load_module()


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def setUp(self):
        self.initialize_mocks()
        self.instance = docker

        self.mock_pillar("data/paas_docker.yaml")

        self.mock_grains()
        self.grains["id"] = "egladil"

    def test_get_image(self):
        container = {"image": "foo", "version": "42"}

        self.assertEqual("foo:42", docker.get_image("not_foo", container))

    def test_list_images(self):
        expected = {"foo", "bar", "quux"}

        self.assertEqual(expected, docker.list_images())

    def test_get_image_without_version(self):
        container = {
            "image": "foo",
        }

        self.assertEqual("foo", docker.get_image("not_foo", container))

    def test_get_image_without_image(self):
        container = {"version": "42"}

        self.assertEqual("not_foo:42", docker.get_image("not_foo", container))

    def test_get_image_without_anything(self):
        self.assertEqual("not_foo", docker.get_image("not_foo", {}))

    def test_get_image_with_numeric_version(self):
        container = {"image": "foo", "version": 2.5}

        self.assertEqual("foo:2.5", docker.get_image("not_foo", container))

    def test_get_subnets(self):
        expected = ["172.18.1.0/24", "172.18.2.0/24", "172.17.0.0/16"]

        self.assertEqual(expected, docker.get_subnets())

    def test_get_subnets_when_none_are_defined(self):
        # Only the default Docker one
        expected = ["172.17.0.0/16"]

        self.grains["id"] = "voidserver"
        self.assertEqual(expected, docker.get_subnets())


if __name__ == "__main__":
    unittest.main()
