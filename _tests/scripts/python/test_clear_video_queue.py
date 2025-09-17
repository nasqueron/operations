#!/usr/bin/env python3

import unittest

from helpers import import_from_path


script_path = "roles/paas-docker/containers/files/mastodon/clear-video-queue.py"
script = import_from_path("script", script_path)


class Testinstance(unittest.TestCase):
    def test_extract_pids(self):
        with open("data/T1492-ps-x-sample.txt", "r") as fd:
            ps_data = [line.strip() for line in fd]

        expected_pids = [11562, 11693, 11895]
        self.assertEqual(expected_pids, script.extract_pids(ps_data))


if __name__ == "__main__":
    unittest.main()
