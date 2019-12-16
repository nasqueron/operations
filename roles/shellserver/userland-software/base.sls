#   -------------------------------------------------------------
#   Salt — Provision base software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Editors
#
#   Disclaimer: We don't caution the views of Richard Stallman
#   or the Church of Emacs positions.
#   See http://geekfeminism.wikia.com/wiki/EMACS_virgins_joke
#   -------------------------------------------------------------

editors:
  pkg.installed:
    - pkgs:
      - joe
      - nano
      - vim
      - {{ packages.emacs }}

#   -------------------------------------------------------------
#   General UNIX utilities
#   -------------------------------------------------------------

utilities:
  pkg.installed:
    - pkgs:
      - cmatrix
      - figlet
      - {{ packages.gpg }}
      - grc
      - moreutils
      - mosh
      - nmap
      - toilet
      - unrar
      - whois
      - woof
      - zip
      {% if grains['os_family'] == 'Debian' %}
      - bsdmainutils
      - dnsutils
      - sockstat
      - sysvbanner
      - toilet-fonts
      {% endif %}
      {% if grains['os'] == 'FreeBSD' %}
      - bind-tools
      - coreutils
      - figlet-fonts
      - gsed
      - sudo
      {% endif %}

utilities_www:
  pkg.installed:
    - pkgs:
      - links
      - lynx
      - w3m

#   -------------------------------------------------------------
#   More exotic shells
#   -------------------------------------------------------------

userland_software_shells:
  pkg.installed:
    - pkgs:
      - fish

#   -------------------------------------------------------------
#   Development
#   -------------------------------------------------------------

dev:
  pkg.installed:
    - pkgs:
      - {{ packages.ag }}
      - autoconf
      - automake
      - cmake
      - colordiff
      - {{ packages.cppunit }}
      - git
      - git-lfs
      - jq
      - ripgrep
      - valgrind
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
  pkg.installed:
    - pkgs:
      - libssl-dev
{% endif %}

#   -------------------------------------------------------------
#   Languages
#   -------------------------------------------------------------

languages_removed:
  pkg.removed:
    - pkgs:
      {% if grains['os_family'] == 'Debian' %}
      - php7.0
      - php7.1
      - php7.2
      {% elif grains['os'] == 'FreeBSD' %}
      - php70
      - php71
      - php72
      - php73
      {% endif %}

languages:
  pkg.installed:
    - pkgs:
      - python3
      - {{ packages.tcl }}
      {% if grains['os_family'] == 'Debian' %}
      - php7.3
      {% elif grains['os'] == 'FreeBSD' %}
      - php74
      {% endif %}

#   -------------------------------------------------------------
#   De facto standard libraries for languages
#   -------------------------------------------------------------

languages_libs:
  pkg.installed:
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
      - {{ packages_prefixes.php }}fileinfo
      - {{ packages_prefixes.php }}filter
      - {{ packages_prefixes.php }}hash
      - {{ packages_prefixes.php }}iconv
      - {{ packages_prefixes.php }}openssl
      - {{ packages_prefixes.php }}pcntl
      - {{ packages_prefixes.php }}session
      - {{ packages_prefixes.php }}xmlreader
      - {{ packages_prefixes.php }}zlib
      # On Debian, these PDO extensions doesn't follow regular names:
      - {{ packages_prefixes.php }}pdo_mysql
      - {{ packages_prefixes.php }}pdo_sqlite
      {% endif %}

      # PECL extensions
      - {{ packages_prefixes.pecl }}yaml

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
    - source: https://github.com/composer/composer/releases/download/1.9.1/composer.phar
    - source_hash: ffd3a22e43cafbeff4b3c66e334efa87a27f309da565259741f111830b6fe1217d7ab31aef47563f14e18ebeeeece46f
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
  pkg.installed:
    - pkgs:
        - {{ packages['aspell-en'] }}
        - {{ packages['aspell-fr'] }}
        - {{ packages.verbiste }}

#   -------------------------------------------------------------
#   Media utilities
#   -------------------------------------------------------------

media:
  pkg.installed:
    - pkgs:
      - {{ packages.exiftool }}
      - id3v2
      - {{ packages.imagemagick }}
      - optipng
      - sox

#   -------------------------------------------------------------
#   Office utilities (bureautique)
#   -------------------------------------------------------------

office_software:
  pkg.installed:
    - pkgs:
      - gcal
      - pdftk
      - qpdf
