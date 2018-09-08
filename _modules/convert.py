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


def to_json_from_pillar_key(key):
    '''
    A function to output a pillar key in JSON.

    CLI Example::

        salt-call --local convert.to_json "Hello world"
    '''
    data = __pillar__.get(key, {})
    return to_json(data)


def to_json(data):
    '''
    A function to convert data to JSON.

    CLI Example::

        salt-call --local convert.to_json "Hello world"
    '''
    return json.dumps(data, indent=4, sort_keys=True)
