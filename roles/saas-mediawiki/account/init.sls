#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set fqdn = pillar["mediawiki_saas"]["main_fqdn"] %}
{% set uids = pillar["uids"] %}
{% set gids = pillar["gids"] %}

#   -------------------------------------------------------------
#   Service account
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mediawiki_group:
  group.present:
    - name: mediawiki
    - gid: {{ gids["mediawiki"] }}
    - system: True

mediawiki_account:
  user.present:
    - name: mediawiki
    - fullname: MediaWiki SaaS
    - uid: {{ uids["mediawiki"] }}
    - gid: {{ gids["mediawiki"] }}
    - system: True
    - home: /var/run/web/{{ fqdn }}

/var/tmp/php/sessions/{{ fqdn }}:
  file.directory:
    - mode: 700
    - user: mediawiki
