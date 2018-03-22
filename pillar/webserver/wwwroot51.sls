#   -------------------------------------------------------------
#   Salt — Sites to provision on the devserver wwwroot51
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

wwwroot51_basedir: /var/51-wwwroot

wwwroot51_directories:
  api:
    user: dereckson
    group: dereckson
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/api.git
  mediawiki-dereckson:
    user: dereckson
    group: dereckson
  rain:
    user: dereckson
    group: dereckson
  saas-mediawiki:
    user: dereckson
    group: mediawiki
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/saas-mediawiki.git
  tools:
    user: dereckson
    group: dereckson
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/tools.git
  wolfplex-api:
    user: dereckson
    group: dereckson
    repository: git@github.com:wolfplex/api-www.git
  www:
    user: dereckson
    group: dereckson
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/www.git
