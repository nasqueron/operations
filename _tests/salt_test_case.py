import yaml

from mocks.dunder import dunder


class SaltTestCase:
    def initialize_mocks(self):
        self.pillar = dunder()
        self.salt = dunder()
        self.grains = dunder()

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

    def mock_salt(self, target=None):
        if not target:
            target = self.instance

        target.__salt__ = self.salt

    def mock_salt_pillar_get(self, target=None):
        if not target:
            target = self.instance

        target.__salt__["pillar.get"] = lambda key: pillar_get(target.__pillar__, key)


def pillar_get(pillar, key, default=""):
    if ":" not in key:
        return pillar.get(key, default)

    keys = key.split(":")

    data = pillar[keys[0]]
    remaining_key = ":".join(keys[1:])

    return pillar_get(data, remaining_key, default)
