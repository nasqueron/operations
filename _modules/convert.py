# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Convert execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-08
#   Description:    Functions related to data format conversions
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import json
import salt.serializers.yaml


#   -------------------------------------------------------------
#   JSON
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def to_json_from_pillar_key(key):
    """
    A function to output a pillar key in JSON.

    CLI Example::

        salt-call --local convert.to_json "Hello world"
    """
    data = __pillar__.get(key, {})
    return to_json(data)


def to_json(data):
    """
    A function to convert data to JSON.

    CLI Example::

        salt-call --local convert.to_json "Hello world"
    """
    return json.dumps(data, indent=4, sort_keys=True)


#   -------------------------------------------------------------
#   YAML
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def _to_dictionary(data, root=None):
    if root is not None:
        return {root: _to_dictionary(data)}

    if type(data) is list:
        dictionary = {}
        for item in data:
            dictionary.update(_to_dictionary(item))
        return dictionary

    if type(data) is tuple and len(data) == 2:
        return dict({data})

    return dict(data)


def to_yaml_dictionary(data, root=None):
    """
    A function to convert data to YAML dictionary.

    CLI Example::

        salt * convert.to_yaml_dictionary '[{"a": "bar"}, {"b": "foo"}]'

        That example will return:
        ```
        a: bar
        b: foo
        ```
    """
    return salt.serializers.yaml.serialize(
        _to_dictionary(data, root), default_flow_style=False
    )


def to_flags(data, enable_prefix="enable-", separator=" "):
    """
    A function to convert a list of flags in a string to enable them.
    """
    return separator.join([enable_prefix + item for item in data])


#   -------------------------------------------------------------
#   Lists and dictionaries
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def to_list(data):
    return list(data)
