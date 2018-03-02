#   -------------------------------------------------------------
#   Salt — Provision software needed by other core roles
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Shells
#   -------------------------------------------------------------

shells:
  pkg:
    - installed
    - pkgs:
      - bash
      - fish
      - zsh
      {% if grains['os'] != 'FreeBSD' %}
      - tcsh
      {% endif %}

{{ dirs.share }}/zsh/site-functions/_pm:
  file.managed:
    # At commit 683d331 - 2017-11-05
    - source: https://raw.githubusercontent.com/Angelmmiguel/pm/master/zsh/_pm
    - source_hash: deea33968be713cdbd8385d3a72df2dd09c444e42499531893133f009f0ce0ea