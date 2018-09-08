#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

# If we pass the JSON as contents, it will be converted into Python,
# so we've a template to call directly the method.

/home/zr/data/servers.json:
  file.managed:
    - source: salt://roles/saltmaster/zemke-rhyne/files/servers.json.jinja
    - template: jinja
    - user: zr
