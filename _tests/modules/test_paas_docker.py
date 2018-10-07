from importlib.machinery import SourceFileLoader
import unittest

salt_test_case = SourceFileLoader('salt_test_case', "salt_test_case.py").load_module()
docker = SourceFileLoader('docker', '../_modules/paas_docker.py').load_module()


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):

    def test_get_image(self):
        container = {
            "image": "foo",
            "version": "42"
        }

        self.assertEqual("foo:42", docker.get_image("not_foo", container))

    def test_get_image_without_version(self):
        container = {
            "image": "foo",
        }

        self.assertEqual("foo", docker.get_image("not_foo", container))

    def test_get_image_without_image(self):
        container = {
            "version": "42"
        }

        self.assertEqual("not_foo:42", docker.get_image("not_foo", container))

    def test_get_image_without_anything(self):
        self.assertEqual("not_foo", docker.get_image("not_foo", {}))

    def test_get_image_with_numeric_version(self):
        container = {
            "image": "foo",
            "version": 2.5
        }

        self.assertEqual("foo:2.5", docker.get_image("not_foo", container))
