#   -------------------------------------------------------------
#   Extract FreeBSD sources
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-01-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

{% set version = grains['kernelrelease'].split("-")[0] %}

freebsd_src:
  cmd.run:
    - name: svnlite checkout https://svn.freebsd.org/base/releng/{{ version }} /usr/src
    - creates: /usr/src/Makefile

{% endif %}
