from importlib.machinery import SourceFileLoader
import unittest


salt_test_case = SourceFileLoader('salt_test_case', "salt_test_case.py").load_module()
forest = SourceFileLoader('forest', "../_modules/forest.py").load_module()


class Testinstance(unittest.TestCase, salt_test_case.SaltTestCase):

    def setUp(self):
        self.initialize_mocks()
        self.instance = forest

        self.mock_pillar('data/forests.yaml')

        self.mock_grains()
        self.grains['id'] = 'egladil'

    def test_exists(self):
        self.assertTrue(forest.exists('lothlorien'))
        self.assertFalse(forest.exists('notexisting'))

    def test_get(self):
        self.assertEqual("lothlorien", forest.get())

    def test_get_when_key_not_exists(self):
        self.grains['id'] = 'notexisting'
        self.assertRaises(KeyError, forest.get)

    def test_list_groups(self):
        self.assertEqual(['caras_galadhon', 'ubiquity'],
                         sorted(forest.list_groups()))

    def test_list_groups_when_there_are_none_for_the_foreest(self):
        self.grains['id'] = 'entwash'
        self.assertEqual(['ubiquity'], forest.list_groups())

    def test_get_groups(self):
        self.assertEqual(['caras_galadhon', 'ubiquity'],
                         sorted(forest.get_groups().keys()))

    def test_list_users(self):
        self.assertEqual(['amdir', 'amroth'],
                         sorted(forest.list_users()))

    def test_get_users(self):
        self.assertEqual(['amdir', 'amroth'],
                         sorted(forest.get_users().keys()))


if __name__ == '__main__':
    unittest.main()
