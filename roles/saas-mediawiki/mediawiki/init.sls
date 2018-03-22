#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Base folder
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/mediawiki:
  file.directory:
    - user: mediawiki
    - group: mediawiki
    - mode: 711

#   -------------------------------------------------------------
#   MediaWiki core
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mediawiki_core_repository:
  git.latest:
    - name: https://gerrit.wikimedia.org/r/p/mediawiki/core.git
    - target: /srv/mediawiki
    - update_head: False
    - user: mediawiki

mediawiki_core_vendor:
  cmd.run:
    - name: composer update --no-dev
    - cwd: /srv/mediawiki
    - runas: mediawiki
    - creates: /srv/mediawiki/vendor

#   -------------------------------------------------------------
#   MediaWiki extensions and skins
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for type in ['extensions', 'skins'] %}
{% for item in salt['pillar.get']('mediawiki_' + type, []) %}
mediawiki_{{ type }}_repository_{{ item }}:
  git.latest:
    - name: https://gerrit.wikimedia.org/r/p/mediawiki/{{ type }}/{{ item }}.git
    - target: /srv/mediawiki/{{ type }}/{{ item }}
    - update_head: False
    - user: mediawiki
{% endfor %}
{% endfor %}

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
