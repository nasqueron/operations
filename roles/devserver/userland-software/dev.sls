#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages, packages_prefixes with context %}

#   -------------------------------------------------------------
#   C/C++
#   -------------------------------------------------------------

devserver_software_dev_c:
  pkg:
    - installed
    - pkgs:
      - {{ packages.boost }}
      - cmocka
      - {{ packages.librabbitmq }}

#   -------------------------------------------------------------
#   Java
#   -------------------------------------------------------------

devserver_software_dev_java:
  pkg:
    - installed
    - pkgs:
      - openjdk8
      - apache-ant
      - maven

#   -------------------------------------------------------------
#   .Net languages
#   -------------------------------------------------------------

devserver_software_dev_dotnet:
  pkg:
    - installed
    - pkgs:
      - mono

#   -------------------------------------------------------------
#   Node
#   -------------------------------------------------------------

devserver_software_dev_node:
  pkg:
    - installed
    - pkgs:
      - {{ packages.node }}
      - npm

devserver_node_packages:
  npm.installed:
    - pkgs:
      - bower
      - browserify
      - gulp
      - grunt
      - jsonlint
      - react-tools
    - require:
      - pkg: devserver_software_dev_node

#   -------------------------------------------------------------
#   PHP
#   -------------------------------------------------------------

devserver_software_dev_php:
  pkg:
    - installed
    - pkgs:
      - {{ packages.phpunit }}

#   -------------------------------------------------------------
#   Python
#   -------------------------------------------------------------

devserver_software_dev_python:
  pkg:
    - installed
    - pkgs:
      - {{ packages_prefixes.python2 }}nltk
      - {{ packages_prefixes.python2 }}numpy
      - {{ packages_prefixes.python2 }}virtualenv

#   -------------------------------------------------------------
#   Ruby
#   -------------------------------------------------------------

devserver_software_dev_ruby:
  pkg:
    - installed
    - pkgs:
      - {{ packages_prefixes.rubygem }}rubocop

#   -------------------------------------------------------------
#   Rust
#   -------------------------------------------------------------

devserver_software_dev_rust:
  pkg:
    - installed
    - pkgs:
      - rust

#   -------------------------------------------------------------
#   Shell
#   -------------------------------------------------------------

devserver_software_dev_shell:
  pkg:
    - installed
    - pkgs:
      - hs-ShellCheck

#   -------------------------------------------------------------
#   TCL
#   -------------------------------------------------------------

devserver_software_dev_tcl:
  pkg:
    - installed
    - pkgs:
      - rlwrap
      - tcllib
      - tclsoap
      - {{ packages.tcltls }}
      - {{ packages.tdom }}

#   -------------------------------------------------------------
#   Web development
#   -------------------------------------------------------------

devserver_software_dev_web:
  pkg:
    - installed
    - pkgs:
      - memcached

#   -------------------------------------------------------------
#   Tools like code review utilities
#
#   Arcanist is installed in the Phabricator states
#   -------------------------------------------------------------

devserver_software_dev_misctools:
  pkg:
    - installed
    - pkgs:
      - git-review
