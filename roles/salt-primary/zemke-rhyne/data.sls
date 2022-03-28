#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set zr_home = "/home/zr" %}

# If we pass the JSON as contents, it will be converted into Python,
# so we've a template to call directly the method.

{{ zr_home }}/data/servers.json:
  file.managed:
    - source: salt://roles/salt-primary/zemke-rhyne/files/servers.json.jinja
    - template: jinja
    - user: zr

zr_authorized_keys:
  cmd.run:
    - runas: zr
    - cwd: {{ zr_home }}
    - name: make clean all
    - onchanges:
      - file: {{ zr_home }}/data/servers.json
    - require:
      - user: zr_account
      - file: {{ zr_home }}/Makefile
