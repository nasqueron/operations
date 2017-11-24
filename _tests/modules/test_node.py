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

    def test_has_web_content(self):
        self.assertTrue(node.has_web_content('.ll/carasgaladhon'))
        self.assertFalse(node.has_web_content('.arda/onodlo'))

        self.assertTrue(node.has_web_content('.arda/onodlo', 'entwash'))

        self.assertFalse(node.has_web_content('notexisting'))

    def test_filter_by_role(self):
        node_key = self.grains['id']

        self.assertEqual(['Caras Galadhon'],
                         node.filter_by_role('items_by_role'))

        self.assertEqual(['Onodlo'],
                         node.filter_by_role('items_by_role', 'entwash'))

        # No role
        self.pillar['nodes'][node_key]['roles'] = []
        self.assertEqual([],
                         node.filter_by_role('items_by_role'))

        # More than one role
        self.pillar['nodes'][node_key]['roles'] = [
            'border',
            'treecity'
        ]
        self.assertEqual(['Caras Galadhon', 'Onodlo'],
                         sorted(node.filter_by_role('items_by_role')))
