#   -------------------------------------------------------------
#   Salt — Hotfixes to mitigate bugs and security issues
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Python 3 alias
#
#   If a the python3 meta-port is missing, we only have executables
#   like python3.9 available. As most of our scripts uses `python3`,
#   it's probably best to ensure an alias by looking for an interpreter.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/usr/local/bin/python3:
 cmd.script:
   - source: salt://hotfixes/files/alias-python3-interpreter.sh
   - creates: /usr/local/bin/python3
{% endif %}
