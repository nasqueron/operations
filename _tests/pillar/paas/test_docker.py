import unittest
import yaml


PILLAR_FILE = '../pillar/paas/docker.sls'


class Testinstance(unittest.TestCase):

    def setUp(self):
        with open(PILLAR_FILE, 'r') as fd:
            self.pillar = yaml.load(fd)

    # nginx needs a host/app_port pair to spawn a configuration
    def test_host_is_paired_with_app_port_option(self):
        for node, services in self.pillar['docker_containers'].items():
            for service, containers in services.items():
                for instance, container in containers.items():
                    if 'host' not in container:
                        continue

                    entry = ':'.join(['docker_containers', node,
                                      service, instance])
                    self.assertIn('app_port', container,
                                  entry + ": app_port missing")
