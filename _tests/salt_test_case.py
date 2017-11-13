import imp
import yaml
from mock import patch


class SaltTestCase:

    def initialize_mocks(self):
        source = imp.load_source('dunder', "mocks/dunder.py")
        self.pillar = source.dunder()
        self.grains = source.dunder()

    def import_data_from_yaml(self, filename):
        with open(filename, 'r') as fd:
            return yaml.load(fd.read())

    def mock_pillar(self, filename=None, target=None):
        if not target:
            target = self.instance

        if filename:
            self.pillar.data = self.import_data_from_yaml(filename)

        target.__pillar__ = self.pillar

    def mock_grains(self, target=None):
        if not target:
            target = self.instance

        target.__grains__ = self.grains
