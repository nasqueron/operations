#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set secret = salt["credentials.read_secret"](
    pillar["mediawiki_saas"]["credentials"]["maintenance"]
) %}

/srv/saas/mediawiki-maintenance/interwiki.sql:
  file.managed:
    - source: salt://roles/saas-mediawiki/mediawiki/files/interwiki/interwiki.sql.jinja
    - makedirs: True
    - user: mediawiki
    - group: mediawiki
    - mode: 644
    - template: jinja
    - context:
        interwiki: {{ pillar['mediawiki_interwikis'] }}

mediawiki_populate_interwiki:
  cmd.run:
    - name: |
        mysql -h$DB_HOST -u$DB_USER -p$DB_PASS \
            < /srv/saas/mediawiki-maintenance/interwiki.sql
    - env:
        - DB_HOST: {{ pillar["mediawiki_saas"]["db"]["host"] }}
        - DB_USER: {{ secret.username }}
        - DB_PASS: {{ secret.password }}
    - onchanges:
        - file: /srv/saas/mediawiki-maintenance/interwiki.sql
