#   -------------------------------------------------------------
#   Salt — Provision IRC software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-04-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages with context %}

#   -------------------------------------------------------------
#   IRC clients
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

irc_clients:
  pkg.installed:
    - pkgs:
      - irssi
      - irssi-scripts
      - weechat
      {% if grains['os'] != 'Debian' and grains['os'] != 'Ubuntu' %}
      # Reference: supremetechs.com/tag/bitchx-removed-from-debian
      - bitchx
      {% endif %}

#   -------------------------------------------------------------
#   Bouncers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

irc_bouncers:
  pkg.installed:
    - pkgs:
      - znc

shroudbnc_dependencies:
  pkg.installed:
    - pkgs:
      - {{ packages["c-ares"] }}
      - libtool
      - swig
      {% if grains['os_family'] == 'Debian' %}
      - tcl-dev
      {% endif %}
      {% if grains['os_family'] == 'RedHat' %}
      - tcl-devel
      {% endif %}

shroudbnc_repo:
  file.directory:
    - name: /usr/local/src/shroudbnc
    - user: builder
    - group: deployment
    - mode: 755
  git.latest:
    - name: https://github.com/gunnarbeutner/shroudbnc
    - target: /usr/local/src/shroudbnc
    - user: builder

shroudbnc_build:
  cmd.run:
    - name: |
        ./autogen.sh && \
        ./configure --prefix=/usr/local && \
        make
    - cwd: /usr/local/src/shroudbnc
    - runas: builder
    - require:
        - git: shroudbnc_repo
    - creates: /usr/local/src/shroudbnc/src/sbnc

shroudbnc_install:
  cmd.run:
    - name: make install
    - cwd: /usr/local/src/shroudbnc
    - onchanges:
        - cmd: shroudbnc_build

#   -------------------------------------------------------------
#   Bots
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

eggdrop_installer:
  file.managed:
    - name: /usr/local/bin/install-eggdrop
    - source: salt://roles/shellserver/userland-software/files/install-eggdrop.sh
    - mode: 755

#   -------------------------------------------------------------
#   Misc
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

irc_misc:
  pkg.installed:
    - pkgs:
      - bitlbee
      - oidentd
      - pisg

oidentd_config:
  file.managed:
    - name: {{ dirs.etc }}/oidentd.conf
    - source: salt://roles/shellserver/userland-software/files/oidentd.conf
    - mode: 644

oidentd_service_config:
  service.running:
    - name: oidentd
    - enable: true
