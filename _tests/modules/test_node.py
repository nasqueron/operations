import imp
import unittest


salt_test_case = imp.load_source('salt_test_case', "salt_test_case.py")
node = imp.load_source('node', "../_modules/node.py")


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):

    def setUp(self):
        self.initialize_mocks()
        self.instance = node

        self.mock_pillar('data/forests.yaml')

        self.mock_grains()
        self.grains['id'] = 'egladil'

    def test_get_wwwroot(self):
        self.assertEqual("wwwroot/lothlorien.forest/egladil",
                         node.get_wwwroot())
        self.assertEqual("wwwroot/entwash.node/www",
                         node.get_wwwroot('entwash'))
