#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages, packages_prefixes with context %}

#   -------------------------------------------------------------
#   C/C++
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_c:
  pkg.installed:
    - pkgs:
      - {{ packages.boost }}
      - cmocka
      - doxygen
      - {{ packages.librabbitmq }}

      {% if grains["os_family"] == "FreeBSD" %}
      - gcc14
      {% endif %}

{% if grains["os_family"] == "FreeBSD" %}
/usr/local/bin/gcc:
  file.symlink:
    - target: /usr/local/bin/gcc14
{% endif %}


#   -------------------------------------------------------------
#   Haskell
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_haskell:
  pkg.installed:
    - pkgs:
      - ghc

#   -------------------------------------------------------------
#   Java
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_java:
  pkg.installed:
    - pkgs:
      - openjdk17
      - apache-ant
      - maven

devserver_software_dev_java_to_prune:
  pkg.removed:
    - pkgs:
      - openjdk8

#   -------------------------------------------------------------
#   .Net languages
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_dotnet:
  pkg.installed:
    - pkgs:
      - mono

#   -------------------------------------------------------------
#   Node
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_node:
  pkg.installed:
    - pkgs:
      - {{ packages.node }}
      - npm

devserver_node_packages:
  npm.installed:
    - pkgs:
      - bower
      - browserify
      - csslint
      - eslint
      - gulp
      - grunt
      - jscs
      - jshint
      - jsonlint
      - react-tools
    - require:
      - pkg: devserver_software_dev_node

#   -------------------------------------------------------------
#   PHP
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_php:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.pecl }}ast
      - {{ packages_prefixes.pecl }}xdebug

# T1728 - xdebug should be disabled by default and invoked when needed
/usr/local/etc/php/ext-20-xdebug.ini:
  file.absent

/opt/phpcpd.phar:
  file.managed:
    - source: https://phar.phpunit.de/phpcpd-6.0.3.phar
    - source_hash: 2cbaea7cfda1bb4299d863eb075e977c3f49055dd16d88529fae5150d48a84cb
    - mode: 755

/opt/phploc.phar:
  file.managed:
    - source: https://phar.phpunit.de/phploc-7.0.2.phar
    - source_hash: 3d59778ec86faf25fd00e3a329b2f9ad4a3c751ca91601ea7dab70f887b0bf46
    - mode: 755

phpdox:
  cmd.run:
    - name: |
        git clone --depth 1 https://github.com/nasqueron/phpdox
        cd phpdox && composer install
    - cwd: /opt
    - creates: /opt/phpdox/phpdox

phpunit:
  cmd.run:
    - name: |
        curl --silent https://sebastian-bergmann.de/gpg.asc | gpg --import
        wget -O /opt/phpunit.phar https://phar.phpunit.de/phpunit-10.phar
        wget -O /opt/phpunit.phar.asc https://phar.phpunit.de/phpunit-10.phar.asc
        cd /opt && gpg --verify ./phpunit.phar.asc
        rm /opt/phpunit.phar.asc
    - creates: /opt/phpunit.phar

{{ dirs.bin }}/run-php-script:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/run-php-script.sh
    - mode: 755

{% for command in ["phan", "phpcpd", "phpdox", "phploc", "phpmd", "phpstan", "phpunit", "psalm", "rector"] %}
{{ dirs.bin }}/{{ command }}:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/run-php-script-alias.sh.jinja
    - mode: 755
    - template: jinja
    - context:
        command: {{ command }}
{% endfor %}

#   -------------------------------------------------------------
#   Python
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_python:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.python3 }}beautifulsoup
      - {{ packages_prefixes.python3 }}nltk
      - {{ packages_prefixes.python3 }}numpy

#   -------------------------------------------------------------
#   Ruby
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_ruby:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.rubygem }}rubocop

#   -------------------------------------------------------------
#   Rust
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_rust:
  pkg.installed:
    - pkgs:
      - rust

{{ dirs.bin }}/rustup-init:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/rustup-init.sh
    - mode: 755

#   -------------------------------------------------------------
#   Shell
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_shell:
  pkg.installed:
    - pkgs:
      - hs-ShellCheck

#   -------------------------------------------------------------
#   TCL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_tcl:
  pkg.installed:
    - pkgs:
      - rlwrap
      - tcllib
      - tclsoap
      - {{ packages.tcltls }}
      - {{ packages.tdom }}

#   -------------------------------------------------------------
#   Web development
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_web:
  pkg.installed:
    - pkgs:
      - memcached

#   -------------------------------------------------------------
#   Editors and IDE
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_vim:
  pkg.installed:
    - pkgs:
      # Vim itself is already declared in core role.
      # FreeBSD also offers nvi in base system.

      # Neovim
      - neovim
      - {{ packages_prefixes.python3 }}pynvim

#   -------------------------------------------------------------
#   Tools like code review utilities
#
#   Arcanist is installed in the Phabricator states
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_misctools:
  pkg.installed:
    - pkgs:
      - git-review

#   -------------------------------------------------------------
#   Nasqueron development and operations
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/create-vault-approle:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/create-vault-approle.sh
    - mode: 755

devserver_software_dev_vault:
  pkg.installed:
   - pkgs:
     - {{ packages_prefixes.python3 }}pyhcl
     - {{ packages_prefixes.python3 }}hvac
     - vault-medusa

#   -------------------------------------------------------------
#   MediaWiki development
#
#   Include tools for some extensions like ProofreadPage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_dev_mediawiki:
  pkg.installed:
    - pkgs:
      - netpbm
      - {{ packages['djvulibre'] }}
