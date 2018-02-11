#   -------------------------------------------------------------
#   Salt — Sites to provision on the devserver wwwroot51
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

wwwroot51_basedir: /var/51-wwwroot

wwwroot51_directories:
  tools:
    user: dereckson
    group: dereckson
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/tools.git
