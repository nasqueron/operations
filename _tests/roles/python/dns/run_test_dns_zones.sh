#!/bin/sh

#   -------------------------------------------------------------
#   Run roles/python/dns/test_dns_zones.py if kzonecheck exists
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Avoid to maintain both BSD and GNU Makefile
#                   for conditional logic .ifdef vs .if defined
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

KZONECHECK=kzonecheck

#   -------------------------------------------------------------
#   Program check
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ! command -v $KZONECHECK > /dev/null; then
    echo "[WARNING] [SKIP] Skip testing roles/dns: kzonecheck missing" >&2
    exit 0
fi

#   -------------------------------------------------------------
#   Run test
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

PYTHONPATH="$(pwd)"
export PYTHONPATH

python roles/python/dns/test_dns_zones.py
