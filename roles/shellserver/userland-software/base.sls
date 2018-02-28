#   -------------------------------------------------------------
#   Salt — Provision base software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages, packages_prefixes with context %}

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

/usr/local/share/zsh/site-functions/_pm:
  file.managed:
    # At commit 683d331 - 2017-11-05
    - source: https://raw.githubusercontent.com/Angelmmiguel/pm/master/zsh/_pm
    - source_hash: deea33968be713cdbd8385d3a72df2dd09c444e42499531893133f009f0ce0ea

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
      - grc
      - nmap
      - toilet
      - tmux
      - tree
      - unrar
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
      - gsed
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
      # PHP extensions
      - {{ packages_prefixes.php }}bcmath
      - {{ packages_prefixes.php }}ctype
      - {{ packages_prefixes.php }}curl
      - {{ packages_prefixes.php }}dom
      - {{ packages_prefixes.php }}gd
      - {{ packages_prefixes.php }}intl
      - {{ packages_prefixes.php }}json
      - {{ packages_prefixes.php }}mbstring
      - {{ packages_prefixes.php }}mysqli
      - {{ packages_prefixes.php }}pdo
      - {{ packages_prefixes.php }}phar
      - {{ packages_prefixes.php }}simplexml
      - {{ packages_prefixes.php }}soap
      - {{ packages_prefixes.php }}tokenizer
      - {{ packages_prefixes.php }}wddx
      - {{ packages_prefixes.php }}xml
      - {{ packages_prefixes.php }}xmlwriter
      - {{ packages_prefixes.php }}xsl
      {% if grains['os_family'] == 'Debian' %}
      # On Debian, these PDO extensions doesn't follow regular names
      # but are installed if you require the legacy extension name.
      - {{ packages_prefixes.php }}mysql
      - {{ packages_prefixes.php }}sqlite3
      {% else %}
      # On Debian, these extensions are now shipped by default:
      - {{ packages_prefixes.php }}filter
      - {{ packages_prefixes.php }}hash
      - {{ packages_prefixes.php }}openssl
      - {{ packages_prefixes.php }}pcntl
      - {{ packages_prefixes.php }}session
      - {{ packages_prefixes.php }}zlib
      # On Debian, these PDO extensions doesn't follow regular names:
      - {{ packages_prefixes.php }}pdo_mysql
      - {{ packages_prefixes.php }}pdo_sqlite
      {% endif %}

      # PHP utilities

      {% if grains['os'] != 'FreeBSD' %}
      # On FreeBSD, PEAR is still a PHP 5.6 package (last tested 2018-02-17).
      # Same for Composer (last tested 2018-02-28)
      - {{ packages.composer }}
      - {{ packages.pear }}
      - {{ packages.phpcs }}
      {% endif %}

      # Standard Python modules
      {% if grains['os'] == 'FreeBSD' %}
      - {{ packages_prefixes.python3 }}gdbm
      - {{ packages_prefixes.python3 }}sqlite3
      {% endif %}

      # TCL
      - tcllib
      - {{ packages.tcltls }}

#   -------------------------------------------------------------
#   Workaround : install composer and phpcs on FreeBSD
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}
/opt/composer:
  file.directory

/opt/composer/composer.phar:
  file.managed:
    - source: https://raw.githubusercontent.com/composer/getcomposer.org/c1ad3667731e/web/download/1.6.3/composer.phar
    - source_hash: 52cb7bbbaee720471e3b34c8ae6db53a38f0b759c06078a80080db739e4dcab6
    - mode: 755

{{ dirs.bin }}/composer:
  file.symlink:
    - target: /opt/composer/composer.phar
    - require:
      - file: /opt/composer/composer.phar

/opt/phpcs:
  file.directory

{% for command in ['phpcs', 'phpcbf'] %}
/opt/phpcs/{{ command }}:
  file.managed:
    - source: https://squizlabs.github.io/PHP_CodeSniffer/{{ command }}.phar
    - skip_verify: True
    - mode: 755

{{ dirs.bin }}/{{ command }}:
  file.symlink:
    - target: /opt/phpcs/{{ command }}
    - require:
      - file: /opt/phpcs/{{ command }}
{% endfor %}
{% endif %}

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
