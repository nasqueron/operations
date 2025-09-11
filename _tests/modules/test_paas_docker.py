#!/usr/bin/env python3

import os
import unittest

import salt_test_case
import paas_docker as docker


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):
    def setUp(self):
        self.initialize_mocks()
        self.instance = docker

        self.mock_pillar("data/paas_docker.yaml")

        self.mock_grains()
        self.grains["id"] = "egladil"

        self.mock_salt()
        self.salt["slsutil.file_exists"] = lambda file: os.path.exists(file)

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

    def test_resolve_vhost_config_file(self):
        config_file = docker.resolve_vhost_config_file("empty", dir="data")

        self.assertEqual("data/empty.conf", config_file)

    def test_resolve_vhost_config_file_when_not_existing(self):
        config_file = docker.resolve_vhost_config_file("foo", dir="notexisting")

        self.assertEqual("notexisting/_default.conf", config_file)

    def test_get_subnets(self):
        expected = ["172.18.1.0/24", "172.18.2.0/24", "172.17.0.0/16"]

        self.assertEqual(expected, docker.get_subnets())

    def test_get_subnets_when_none_are_defined(self):
        # Only the default Docker one
        expected = ["172.17.0.0/16"]

        self.grains["id"] = "voidserver"
        self.pillar["docker_networks"] = {}
        self.assertEqual(expected, docker.get_subnets())

    def test_format_env_list(self):
        expression = {"foo": "bar", "quux": 42}

        expected = "foo: bar; quux: 42"
        self.assertEqual(
            expected, docker.format_env_list(expression, assign_op=": ", separator="; ")
        )

    def test_is_nginx_service(self):
        full_service = self.pillar["docker_containers"]["web_service"]
        self.assertTrue(docker.is_nginx_service(full_service))

    def test_is_nginx_service_when_its_not(self):
        full_service = self.pillar["docker_containers"]["non_web_service"]
        self.assertFalse(docker.is_nginx_service(full_service))


if __name__ == "__main__":
    unittest.main()
