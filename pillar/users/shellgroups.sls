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
