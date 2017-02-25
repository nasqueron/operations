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
      - cmatrix
      - figlet
      - nmap
      - toilet
      - tree
      - whois
      - woof
      {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
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
      {% if grains['os_family'] == 'Debian' %}
      - libcppunit-dev
      - silversearcher-ag
      {% endif %}
      {% if grains['os'] == 'FreeBSD' %}
      - cppunit
      - the_silver_searcher
      {% else %}
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
      {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
      - php7.0
      {% elif grains['os'] == 'FreeBSD' %}
      - php70
      {% endif %}

languages:
  pkg:
    - installed
    - pkgs:
      - python3
      {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
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
      {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
      - tcl-tls
      {% elif grains['os'] == 'FreeBSD' %}
      - tcltls
      {% endif %}

#   -------------------------------------------------------------
#   Spelling and language utilities
#   -------------------------------------------------------------

spelling:
  pkg:
    - installed
    - pkgs:
        - verbiste
      {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
        - aspell-fr
      {% elif grains['os'] == 'FreeBSD' %}
        - fr-aspell
      {% endif %}
