#   -------------------------------------------------------------
#   Salt — Certificates module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Functions related to certificates management
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

from typing import Dict


def get_certificates_options() -> Dict:
    """
    Resolve the pillar data for certificates options.
    Merge certificates_default_options and certificates_options dictionaries.
    """

    options = {}
    default_options = __pillar__.get("certificates_default_options", {})
    certificates_options = __pillar__.get("certificates_options", {})

    for certificate in __pillar__.get("certificates", []):
        certificate_options = default_options.copy()

        for key, value in certificates_options.get(certificate, {}).items():
            certificate_options[key] = value

        options[certificate] = certificate_options

    return options
