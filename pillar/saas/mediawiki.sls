#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

mediawiki_extensions:
  - CategoryTree
  - Cite
  - CodeEditor
  - ConfirmEdit
  - ContactPage
  - Echo
  - FlaggedRevs
  - Flow
  - Gadgets
  - ParserFunctions
  - Poem
  - ProofreadPage
  - Scribunto
  - SyntaxHighlight_GeSHi
  - Thanks
  - WikiEditor

mediawiki_skins:
  - MinervaNeue
  - MonoBook
  - Timeless
  - Vector

mediawiki_saas:
  directory: /srv/saas/mediawiki
  mediawiki_directory: /srv/mediawiki
  fastcgi_url: unix:/var/run/web/wikis.nasqueron.org/php-fpm.sock
  db:
    host: 172.27.27.9
    user: saas-mediawiki
  credentials:
    db: dbserver/cluster-B/users/saas-mediawiki
    secret_key: nasqueron/mediawiki/secret_key

mediawiki_datastores:
  ###
  ### Nasqueron
  ###
  - agora.nasqueron.org

  ###
  ### MediaWiki code tests
  ###
  - migration.mediawiki.test.ook.space

  ###
  ### Other wikis hosted on the Nasqueron servers
  ###
  - arsmagica.espace-win.org
  - inidal.espace-win.org
  - utopia.espace-win.org
  - www.wolfplex.org
