#   -------------------------------------------------------------
#   Salt — Provision base software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages, packages_prefixes with context %}

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
      - mosh
      - cmatrix
      - figlet
      - nmap
      - toilet
      - tmux
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
      - sudo
      - coreutils
      - wget
      {% endif %}

utilities_www:
  pkg:
    - installed
    - pkgs:
      - links
      - w3m
      - lynx

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
      - colordiff
      - cmake
      - valgrind
      - jq
      - {{ packages.cppunit }}
      - {{ packages.ag }}
      {% if grains['os'] == 'FreeBSD' %}
      - hub
      {% else %}
      - arcanist
      - clang
      - llvm
      - strace
      {% endif %}

{% if grains['os_family'] == 'Debian' %}
dev_popular_libs:
  pkg:
    - installed
    - pkgs:
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
      # PHP
      - {{ packages_prefixes.php }}bcmath
      - {{ packages_prefixes.php }}ctype
      - {{ packages_prefixes.php }}curl
      - {{ packages_prefixes.php }}dom
      - {{ packages_prefixes.php }}filter
      - {{ packages_prefixes.php }}gd
      - {{ packages_prefixes.php }}hash
      - {{ packages_prefixes.php }}intl
      - {{ packages_prefixes.php }}json
      - {{ packages_prefixes.php }}mbstring
      - {{ packages_prefixes.php }}mysqli
      - {{ packages_prefixes.php }}openssl
      - {{ packages_prefixes.php }}pcntl
      - {{ packages_prefixes.php }}pdo
      - {{ packages_prefixes.php }}pdo_mysql
      - {{ packages_prefixes.php }}pdo_sqlite
      - {{ packages_prefixes.php }}phar
      - {{ packages_prefixes.php }}session
      - {{ packages_prefixes.php }}simplexml
      - {{ packages_prefixes.php }}soap
      - {{ packages_prefixes.php }}tokenizer
      - {{ packages_prefixes.php }}wddx
      - {{ packages_prefixes.php }}xml
      - {{ packages_prefixes.php }}xmlwriter
      - {{ packages_prefixes.php }}xsl
      - {{ packages_prefixes.php }}zlib
      - {{ packages.composer }}
      - {{ packages.pear }}
      - {{ packages.phpcs }}
      # TCL
      - tcllib
      - {{ packages.tcltls }}

#   -------------------------------------------------------------
#   Spelling and language utilities
#   -------------------------------------------------------------

spelling:
  pkg:
    - installed
    - pkgs:
        - {{ packages.verbiste }}
        - {{ packages['aspell-fr'] }}
        - {{ packages['aspell-en'] }}

#   -------------------------------------------------------------
#   Media utilities
#   -------------------------------------------------------------

media:
  pkg:
    - installed
    - pkgs:
      - {{ packages.exiftool }}
      - {{ packages.imagemagick }}
