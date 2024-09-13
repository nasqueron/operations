#   -------------------------------------------------------------
#   Salt — Prune portsnap
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   T2019
#   Don't use portsnap anymore for FreeBSD ports
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains["os"] == "FreeBSD" %}

/var/db/portsnap:
  file.absent

/usr/ports/.portsnap.INDEX:
  file.absent

portsnap:
  pkg.removed

{% endif %}
