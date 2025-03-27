#   -------------------------------------------------------------
#   Salt — Provision Dovecot
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

#   -------------------------------------------------------------
#   Port options
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/db/ports/mail_dovecot/options:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/port_options
    - template: jinja
    - mode: 644
    - context:
        args:
          category: mail
          name: mail_dovecot
          options:
            set:
              - PGSQL

#   -------------------------------------------------------------
#   Build and install package
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dovecot_build_port:
  cmd.run:
    - name: |
        make build package deinstall reinstall
        pkg lock --yes mail_dovecot
    - cwd: /usr/ports/databases/mail_dovecot
    - creates: /usr/local/etc/dovecot

{% else %}

dovecot:
  pkg.installed

{% endif %}
