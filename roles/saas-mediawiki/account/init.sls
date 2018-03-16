#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Service account
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mediawiki_group:
  group.present:
    - name: mediawiki
    - gid: 3004
    - system: True

mediawiki_account:
  user.present:
    - name: mediawiki
    - fullname: MediaWiki SaaS
    - uid: 3004
    - gid: 3004
    - home: /var/run/mediawiki
