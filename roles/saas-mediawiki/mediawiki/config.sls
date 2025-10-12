#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   MediaWiki configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/mediawiki/LocalSettings.php:
  file.managed:
    - source: salt://roles/saas-mediawiki/mediawiki/files/LocalSettings.php
    - user: mediawiki
    - group: mediawiki
    - mode: 644
    - template: jinja
    - context:
        directory: {{ pillar['mediawiki_saas']['directory'] }}

#   -------------------------------------------------------------
#   MediaWiki logs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/log/mediawiki:
  file.directory:
    - user: mediawiki
    - group: mediawiki
    - mode: 755
