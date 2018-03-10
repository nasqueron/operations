#   -------------------------------------------------------------
#   Salt — Salt configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages_prefixes with context %}

#   -------------------------------------------------------------
#   Does Salt use Python 2 or Python 3?
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['pythonversion'][0] == 2 %}
{% set prefix = packages_prefixes['python2'] %}
{% else %}
{% set prefix = packages_prefixes['python3'] %}
{% endif %}

#   -------------------------------------------------------------
#   Dependencies for Docker Salt minions
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{prefix}}docker-py:
  pkg.installed
