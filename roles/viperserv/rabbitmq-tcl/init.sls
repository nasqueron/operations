#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-17
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   Build rabbitmq-tcl
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rabbitmq-tcl_dependencies:
  pkg.installed:
    - pkgs:
      - {{ packages.librabbitmq }}

rabbitmq-tcl_repo:
  file.directory:
    - name: /opt/rabbitmq-tcl
    - user: builder
    - group: deployment
    - dir_mode: 755
  git.latest:
    - name: https://devcentral.nasqueron.org/source/rabbitmq-tcl.git
    - target: /opt/rabbitmq-tcl
    - user: builder

rabbitmq-tcl_build:
  {% if grains['os'] == 'FreeBSD' %}
  file.managed:
    - name: /opt/rabbitmq-tcl/Makefile-FreeBSD.patch
    - source: salt://roles/viperserv/rabbitmq-tcl/files/Makefile-FreeBSD.patch
    - user: builder
    - group: deployment
  cmd.run:
    - name: |
        patch -p1 < Makefile-FreeBSD.patch
        cd src/
        gmake
  {% else %}
  cmd.run:
    - name: cd src && make
  {% endif %}
    - runas: builder
    - cwd: /opt/rabbitmq-tcl
    - creates: /opt/rabbitmq-tcl/build/rabbitmq.so

#   -------------------------------------------------------------
#   Install rabbitmq-tcl
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/viperserv/lib/rabbitmq.so:
  file.symlink:
    - target: /opt/rabbitmq-tcl/build/rabbitmq.so
    - user: viperserv
    - group: nasqueron-irc
