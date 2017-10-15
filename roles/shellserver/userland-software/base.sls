#   -------------------------------------------------------------
#   Salt — Provision base software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   Shells
#   -------------------------------------------------------------

shells:
  pkg:
    - installed
    - pkgs:
      - bash
      - fish
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
      - {{ packages.emacs }}

#   -------------------------------------------------------------
#   General UNIX utilities
#   -------------------------------------------------------------

utilities:
  pkg:
    - installed
    - pkgs:
      - cmatrix
      - figlet
      - nmap
      - toilet
      - tree
      - whois
      - woof
      {% if grains['os_family'] == 'Debian' %}
      - bsdmainutils
      - sockstat
      - dnsutils
      - sysvbanner
      - toilet-fonts
      {% endif %}
      {% if grains['os'] == 'FreeBSD' %}
      - figlet-fonts
      - bind-tools
      {% endif %}

#   -------------------------------------------------------------
#   Development
#   -------------------------------------------------------------

dev:
  pkg:
    - installed
    - pkgs:
      - autoconf
      - automake
      - git
      - arcanist
      - colordiff
      - strace
      - cmake
      - valgrind
      - {{ packages.cppunit }}
      - {{ packages.ag }}
      {% if grains['os_family'] == 'Debian' %}
      - php7.1-curl
      {% endif %}
      {% if grains['os'] != 'FreeBSD' %}
      - clang
      - llvm
      {% endif %}

dev_popular_libs:
  pkg:
    - installed
    - pkgs:
      {% if grains['os_family'] == 'Debian' %}
      - libssl-dev
      {% endif %}

#   -------------------------------------------------------------
#   Languages
#   -------------------------------------------------------------

languages_removed:
  pkg:
    - removed
    - pkgs:
      {% if grains['os_family'] == 'Debian' %}
      - php7.0
      {% elif grains['os'] == 'FreeBSD' %}
      - php70
      {% endif %}

languages:
  pkg:
    - installed
    - pkgs:
      - python3
      {% if grains['os_family'] == 'Debian' %}
      - tcl8.6-dev
      - php7.1
      {% elif grains['os'] == 'FreeBSD' %}
      - tcl86
      - php71
      {% endif %}

#   -------------------------------------------------------------
#   De facto standard libraries for languages
#   -------------------------------------------------------------

languages_libs:
  pkg:
    - installed
    - pkgs:
      - tcllib
      - {{ packages.tcltls }}

#   -------------------------------------------------------------
#   Spelling and language utilities
#   -------------------------------------------------------------

spelling:
  pkg:
    - installed
    - pkgs:
        - verbiste
        - {{ packages['aspell-fr'] }}
