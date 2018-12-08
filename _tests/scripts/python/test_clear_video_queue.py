from importlib.machinery import SourceFileLoader
import unittest


path = "roles/paas-docker/containers/files/mastodon/clear-video-queue.py"
script = SourceFileLoader('script', "../" + path).load_module()


class Testinstance(unittest.TestCase):

    def test_extract_pids(self):
        with open("data/T1492-ps-x-sample.txt", "r") as fd:
            ps_data = [line.strip() for line in fd]

        expected_pids = [11562, 11693, 11895]
        self.assertEqual(expected_pids, script.extract_pids(ps_data))
