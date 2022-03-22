#   -------------------------------------------------------------
#   Extract FreeBSD sources
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-01-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

{% set version = grains['kernelrelease'].split("-")[0] %}

{% if version >= "13.0" %}
git:
  pkg.installed
{% endif %}

freebsd_src:
  cmd.run:
    {% if version < "13.0" %}
    - name: svnlite checkout https://svn.freebsd.org/base/releng/{{ version }} /usr/src
    {% else %}
    - name: git clone --depth=1 --single-branch -b releng/{{ version }} https://git.freebsd.org/src.git /usr/src
    {% endif %}
    - creates: /usr/src/Makefile

{% endif %}
