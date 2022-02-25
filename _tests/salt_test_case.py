from importlib.machinery import SourceFileLoader
import yaml


class SaltTestCase:
    def initialize_mocks(self):
        source = SourceFileLoader("dunder", "mocks/dunder.py").load_module()
        self.pillar = source.dunder()
        self.grains = source.dunder()

    @staticmethod
    def import_data_from_yaml(filename):
        with open(filename, "r") as fd:
            return yaml.safe_load(fd.read())

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
