#   -------------------------------------------------------------
#   Poudriere
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   General configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/poudriere.conf:
  file.managed:
    - source: salt://roles/devserver/poudriere/files/poudriere.conf
    - template: jinja
    - context:
        poudriere: {{ pillar["poudriere"] }}
