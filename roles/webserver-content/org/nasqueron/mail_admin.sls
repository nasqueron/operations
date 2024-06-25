#   -------------------------------------------------------------
#   Salt — Provision admin.mail.nasqueron.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Base directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/admin.mail:
  file.directory:
    - user: deploy
    - group: wheel
    - dir_mode: 755

#   -------------------------------------------------------------
#   Deploy mail
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/libexec/alkane/admin.mail.nasqueron.org:
  file.directory:
    - user: root
    - group: web
    - dir_mode: 755

/usr/local/libexec/alkane/admin.mail.nasqueron.org/init:
  file.managed:
    - source: salt://roles/webserver-content/org/nasqueron/files/recipes/admin.mail.nasqueron.org/init.sh
    - mode: 755

/usr/local/libexec/alkane/admin.mail.nasqueron.org/update:
  file.managed:
    - source: salt://roles/webserver-content/org/nasqueron/files/recipes/admin.mail.nasqueron.org/update.sh
    - mode: 755

www_admin_mail_build:
  cmd.run:
    - name: alkane deploy admin.mail.nasqueron.org
    - runas: deploy

/var/wwwroot/nasqueron.org/admin.mail/var:
  file.directory:
    - user: web-org-nasqueron-mail-admin
    - group: web
    - dir_mode: 711
    - recurse:
      - user
      - group
      - mode
