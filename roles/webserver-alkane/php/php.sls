#   -------------------------------------------------------------
#   Salt — Provision PHP websites — php-fpm pools
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages, packages_prefixes with context %}

{% set is_devserver = salt['node.has_role']('devserver') %}

#   -------------------------------------------------------------
#   Install PHP through packages
#
#   The extensions cover a standard PHP installation,
#   and the needs of the known applications we use.
#
#   If you need Debian compatibility, this list should be
#   replaced by the shellserver one.
#
#   The devserver role already install PHP through two layers:
#     - roles/shellserver/userland-software/base.sls
#     - roles/devserver/userland-software/dev.sls
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if not is_devserver %}

php_software:
  pkg.installed:
    - pkgs:
      - php83

      # PHP extensions
      - {{ packages_prefixes.php }}bcmath
      - {{ packages_prefixes.php }}curl
      - {{ packages_prefixes.php }}gd
      - {{ packages_prefixes.php }}intl
      - {{ packages_prefixes.php }}mbstring
      - {{ packages_prefixes.php }}soap
      - {{ packages_prefixes.php }}xml
      - {{ packages_prefixes.php }}xsl

      - {{ packages_prefixes.php }}calendar
      - {{ packages_prefixes.php }}ctype
      - {{ packages_prefixes.php }}dom
      - {{ packages_prefixes.php }}fileinfo
      - {{ packages_prefixes.php }}filter
      - {{ packages_prefixes.php }}gettext
      - {{ packages_prefixes.php }}iconv
      - {{ packages_prefixes.php }}mysqli
      - {{ packages_prefixes.php }}pcntl
      - {{ packages_prefixes.php }}pdo
      - {{ packages_prefixes.php }}phar
      - {{ packages_prefixes.php }}session
      - {{ packages_prefixes.php }}simplexml
      - {{ packages_prefixes.php }}sodium
      - {{ packages_prefixes.php }}sockets
      - {{ packages_prefixes.php }}tokenizer
      - {{ packages_prefixes.php }}xmlreader
      - {{ packages_prefixes.php }}xmlwriter
      - {{ packages_prefixes.php }}zip
      - {{ packages_prefixes.php }}zlib

      - {{ packages_prefixes.php }}pdo_mysql
      - {{ packages_prefixes.php }}pdo_pgsql
      - {{ packages_prefixes.php }}pdo_sqlite

      # PECL extensions
      - {{ packages_prefixes.pecl }}yaml

      # PHP utilities
      - {{ packages.composer }}

{% endif %}

#   -------------------------------------------------------------
#   PHP global configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/php.ini:
  file.managed:
    - source: salt://roles/webserver-alkane/php/files/php.ini
    - template: jinja
    - context:
        tasks:
          {% if is_devserver %}
          # Since D2655, devserver uses /var/run/mysql
          # This is not needed on production as MySQL is on another node
          - set_mysql_sockets
          {% else %}
          # Enable Opcache, with aggressive caching
          # This is not suitable in devserver: it needs a php-fpm restart
          # when a PHP site is updated to invalidate the cache
          - optimize_opcache
          {% endif %}

{% for build in pillar.get('php_custom_builds', {}) %}
/opt/php/{{ build }}/lib/php.ini:
  file.managed:
    - source: {{ dirs.etc }}/php.ini:
{% endfor %}

# T1728 - xdebug should be disabled by default and invoked when needed
/usr/local/etc/php/ext-20-xdebug.ini:
  file.absent
