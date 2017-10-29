#   -------------------------------------------------------------
#   Salt — Service groups list
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2017-01-24
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Nasqueron
#   -------------------------------------------------------------

shellgroups:
  ops:
    gid: 3001
    description: Nasqueron Operations
    members:
      - dereckson
      - sandlayth
  chaton-dev:
    gid: 827
    description: Bonjour chaton
    members:
      - hlp 
  deployment:
    gid: 828
    description: Build softwares to be installed on the servers
    members:
      - dereckson
  nasqueron-irc:
    gid: 829
    description: Manages IRC bots used for Nasqueron projects
    members:
      - dereckson
      - sandlayth
