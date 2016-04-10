#   -------------------------------------------------------------
#   Salt — Provision base software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Shells
#   -------------------------------------------------------------

shells:
  pkg:
    - installed
    - pkgs:
      - bash
      - tcsh
      - zsh

#   -------------------------------------------------------------
#   Editors
#
#   Disclaimer: We don't caution the views of Richard Stallman
#   or the Church of Emacs positions.
#   See http://geekfeminism.wikia.com/wiki/EMACS_virgins_joke
#   -------------------------------------------------------------

editors:
  pkg:
    - installed
    - pkgs:
      - vim
      - nano
      - joe
      {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
      - emacs-nox
      {% elif grains['os'] == 'FreeBSD' %}
      - emacs-nox11
      {% endif %}


#   -------------------------------------------------------------
#   General UNIX utilities
#   -------------------------------------------------------------

utilities:
  pkg:
    - installed
    - pkgs:
      - tree
      - whois

#   -------------------------------------------------------------
#   Languages
#   -------------------------------------------------------------

languages:
  pkg:
    - installed
    - pkgs:
      - python3
      {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
      - tcl8.6-dev
      - php7.0
      {% elif grains['os'] == 'FreeBSD' %}
      - tcl86
      - php70
      {% endif %}
