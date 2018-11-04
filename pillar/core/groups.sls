#   -------------------------------------------------------------
#   Salt — Users accounts list
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Users groups
#
#   These groups will be deployed on each servers if included in
#   shellgroups_ubiquity or in some servers forests if included
#   in the state shellgroups_by_forest.
#
#   As for users, the mere fact to add a group here is a no-op.
#   These mapping are defined in the forests.sls pillar file.
#
#   Sort the groups by GIDs.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

shellgroups:

  shell:
    gid: 200
    title: Eglide shell users
    description: >
        Provide an account to use on the Eglide shell hosting project servers.
    members:
      - adrien
      - akoe
      - amj
      - ariel
      - axe
      - balaji
      - c2c
      - chan
      - dereckson
      - erol
      - harshcrop
      - hlp
      - kazuya
      - khmerboy
      - kumkum
      - pkuz
      - rama
      - rashk0
      - ringa
      - rix
      - sandlayth
      - shark
      - thrx
      - tomjerr
      - vigilant
      - windu
      - xcombelle
      - xray

  chaton-dev:
    gid: 827
    description: Manage Bonjour chaton service
    members:
      - hlp

  nasqueron-irc:
    gid: 829
    description: Manage IRC bots used for Nasqueron projects
    members:
      - dereckson
      - sandlayth

  ops:
    gid: 3001
    title: Nasqueron Operations
    description: >
        Maintain the servers infrastructure. As such, members of this
        group have a root access everywhere.
    members:
      - dereckson
      - sandlayth

  deployment:
    gid: 3003
    title: Nasqueron Deployment
    description: >
        Build software to be installed on the servers.
        Deploy web sites and services files.
    members:
      - dereckson

  nasquenautes:
    gid: 3004
    title: Nasqueron servers users
    description: >
        Provide an account on Nasqueron development servers.
    members:
      - dereckson
      - rama
      - sandlayth
      - xcombelle
