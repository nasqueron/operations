#   -------------------------------------------------------------
#   Mail - Postfix
#   -------------------------------------------------------------
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/mailserver/postfix.sls
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% from "roles/mailserver/map.jinja" import postfix_dirs with context %}
{% set db = pillar["postfix_config"]["db"] %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

postfix_install:
  pkg.installed:
    - pkgs:
      - maildrop
      - mailman
      - postfix-pgsql
      - postfix-policyd-spf-perl

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/postfix/main.cf:
  file.managed:
    - source: salt://roles/mailserver/postfix/files/main.cf
    - template: jinja
    - context:
        dirs: {{ dirs }}
        postfix_dirs: {{ postfix_dirs }}

{{ dirs.etc }}/postfix/postfix-to-mailman.py:
  file.managed:
    - source: salt://roles/mailserver/postfix/files/postfix-to-mailman.py
    - template: jinja
    - context:
        dirs: {{ dirs }}
        mailmanAbuse: postmaster@nasqueron.org

/usr/local/etc/postfix/postfix-files:
  file.symlink:
    - target: /usr/local/libexec/postfix/postfix-files

{{ dirs.etc }}/postfix/pgsql-virtual-mailbox-domains.cf:
  file.managed:
    - source: salt://roles/mailserver/postfix/files/pgsql-virtual-mailbox-domains.cf
    - template: jinja
    - context:
        db: &dbcontext
          database: {{ db["database"] }}
          username: {{ salt["credentials.get_username"](db["credential"]) }}
          password: {{ salt["credentials.get_password"](db["credential"]) }}
          host: {{ pillar["nasqueron_services"][db["service"]] }}

{{ dirs.etc }}/postfix/pgsql-virtual-mailbox-maps.cf:
  file.managed:
    - source: salt://roles/mailserver/postfix/files/pgsql-virtual-mailbox-maps.cf
    - template: jinja
    - context:
        db: *dbcontext

{{ dirs.etc }}/postfix/pgsql-virtual-alias-maps.cf:
  file.managed:
    - source: salt://roles/mailserver/postfix/files/pgsql-virtual-alias-maps.cf
    - template: jinja
    - context:
        db: *dbcontext

{{ dirs.etc }}/postfix/master.cf:
  file.managed:
    - source: salt://roles/mailserver/postfix/files/master.cf
    - template: jinja

{{ dirs.etc }}/postfix/dynamicmaps.cf:
  file.managed:
    - source: salt://roles/mailserver/postfix/files/dynamicmaps.cf
    - template: jinja
    - context:
        dirs: {{ dirs }}

postfix_running:
  service.running:
    - name: postfix
    - enable: True
