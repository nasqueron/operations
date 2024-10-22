#   -------------------------------------------------------------
#   Salt — Provision mail.nasqueron.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Base directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/mail:
  file.directory:
    - user: deploy
    - group: wheel
    - dir_mode: 755

#   -------------------------------------------------------------
#   Root content
#
#   :: phpinfo - This is important to be transparent about the
#                capabilities of our webmails installations.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/mail/phpinfo.php:
  file.managed:
    - user: deploy
    - mode: 644
    - contents: |
        <?php phpinfo(); ?>

#   -------------------------------------------------------------
#   Alkane deployment
#
#   :: Snappymail
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/libexec/alkane/mail.nasqueron.org:
  file.directory:
    - user: root
    - group: web
    - dir_mode: 755

/usr/local/libexec/alkane/mail.nasqueron.org/init:
  file.managed:
    - source: salt://roles/webserver-content/org/nasqueron/files/recipes/mail.nasqueron.org/init.sh
    - mode: 755

/usr/local/libexec/alkane/mail.nasqueron.org/update:
  file.managed:
    - source: salt://roles/webserver-content/org/nasqueron/files/recipes/mail.nasqueron.org/update.sh
    - mode: 755

www_mail_build:
  cmd.run:
    - name: alkane deploy mail.nasqueron.org
    - runas: deploy
    - creates: /var/wwwroot/nasqueron.org/mail/snappymail/index.php

#   -------------------------------------------------------------
#   Snappy mail
#
#   :: Data
#   :: Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/dataroot/nasqueron/snappymail:
  file.directory:
    - user: web-org-nasqueron-mail
    - group: web
    - makedirs: true

/var/wwwroot/nasqueron.org/mail/snappymail/include.php:
  file.managed:
    - source: salt://roles/webserver-content/org/nasqueron/files/snappymail/include.php
    - template: jinja
    - context:
        data_path: /var/dataroot/nasqueron/snappymail
