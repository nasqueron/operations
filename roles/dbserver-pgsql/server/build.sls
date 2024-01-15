#   -------------------------------------------------------------
#   Salt — PostgreSQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

#   -------------------------------------------------------------
#   Port options
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/db/ports/databases_postgresql15-server/options:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/port_options
    - template: jinja
    - mode: 644
    - context:
        args:
          category: databases
          name: postgresql15-server
          options:
            set:
              - XML

#   -------------------------------------------------------------
#   Build and install package
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

postgresql_build_dependencies:
  pkg.installed:
    - pkgs:
      - dialog4ports
      - gmake
      - pkgconf
      - gettext

postgresql_build_port:
  cmd.run:
    - name: |
        make build package deinstall reinstall
        pkg lock --yes postgresql15-server
    - cwd: /usr/ports/databases/postgresql15-server
    - creates: /usr/local/bin/postgres

{% endif %}
