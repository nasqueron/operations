#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

mediawiki_extensions:
  - Cite

mediawiki_skins:
  - MonoBook
  - Timeless
  - Vector

mediawiki_saas:
  directory: /var/51-wwwroot/saas-mediawiki

mediawiki_datastores:
  ###
  ### Nasqueron
  ###
  - agora.nasqueron.org

  ###
  ### Other wikis hosted on the Nasqueron servers
  ###
  - arsmagica.espace-win.org
  - utopia.espace-win.org
  - www.wolfplex.org
