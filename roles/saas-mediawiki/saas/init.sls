#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set saas = pillar["mediawiki_saas"] %}

#   -------------------------------------------------------------
#   Base directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

saas_mediawiki_parent_directory:
  file.directory:
    - name: /srv/saas

#   -------------------------------------------------------------
#   SaaS entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

saas_mediawiki:
  git.latest:
    - name: https://devcentral.nasqueron.org/source/saas-mediawiki.git
    - target: {{ saas["directory"] }}
    - update_head: False
    - user: mediawiki

saas_mediawiki_vendor:
  cmd.run:
    - name: composer update --no-dev
    - cwd: {{ saas["directory"] }}
    - runas: mediawiki
    - creates: {{ saas["directory"] }}/vendor

#   -------------------------------------------------------------
#   MediaWiki SaaS credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ saas["directory"] }}/.env
  file.managed:
    - source: salt://roles/saas-mediawiki/saas/files/dot.env
    - user: mediawiki
    - group: mediawiki
    - mode: 400
    - template: jinja
    - context:
        secret_key: {{ credentials.get_password(saas["credentials"]["secret_key"]) }}
        db_pass: {{ credentials.get_password(saas["credentials"]["db"]) }}
