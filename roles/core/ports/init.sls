#   -------------------------------------------------------------
#   Extract FreeBSD ports
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-01-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

portsnap:
  pkg.installed

/usr/ports:
  cmd.run:
    - name: portsnap --interactive fetch extract
    - creates: /usr/ports/Makefile

{% endif %}
