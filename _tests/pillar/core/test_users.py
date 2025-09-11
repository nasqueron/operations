#!/usr/bin/env python3

import unittest
import yaml


PILLAR_FILE = "../pillar/core/users.sls"

USER_PROPERTIES_MANDATORY = set(
    [
        "fullname",
        "uid",
    ]
)
USER_PROPERTIES_OPTIONAL = set(
    [
        "class",
        "devserver_tasks",
        "everywhere_tasks",
        "shell",
        "yubico_keys",
    ]
)

USER_PROPERTIES_AT_LEAST_ONE_OF_MANDATORY = [
    set(
        [
            "ssh_keys",
            "ssh_keys_by_forest",
        ]
    ),
]

for keys in USER_PROPERTIES_AT_LEAST_ONE_OF_MANDATORY:
    USER_PROPERTIES_OPTIONAL.update(keys)


class Testinstance(unittest.TestCase):
    def setUp(self):
        with open(PILLAR_FILE, "r") as fd:
            self.pillar = yaml.safe_load(fd)

    # users must have a username, an UID and SSH keys
    def test_users_properties(self):
        is_valid = True
        errors = []

        for user, properties in self.pillar["shellusers"].items():
            missing_properties = USER_PROPERTIES_MANDATORY - set(properties)
            if missing_properties:
                errors.append(f"  Missing properties for {user}: {missing_properties}")
                is_valid = False

            invalid_properties = (
                set(properties) - USER_PROPERTIES_MANDATORY - USER_PROPERTIES_OPTIONAL
            )
            if invalid_properties:
                errors.append(f"  Invalid properties for {user}: {invalid_properties}")
                is_valid = False

            for keys_group in USER_PROPERTIES_AT_LEAST_ONE_OF_MANDATORY:
                key_found = False
                for key in keys_group:
                    if key in properties:
                        key_found = True
                        break

                if not key_found:
                    errors.append(
                        f"  Missing properties for {user}: at least one of {keys_group}"
                    )
                    is_valid = False

        self.assertTrue(is_valid, "\n" + "\n".join(errors))


if __name__ == "__main__":
    unittest.main()
