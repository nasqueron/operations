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
  rain:
    user: dereckson
    group: dereckson
  tools:
    user: dereckson
    group: dereckson
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/tools.git
  www:
    user: dereckson
    group: dereckson
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/www.git
