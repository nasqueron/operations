#   -------------------------------------------------------------
#   Salt — Users accounts list
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
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
#   GIDs are now centralized in pillar/core/ids.sls
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

shellgroups:

  shell:
    title: Eglide shell users
    description: >
        Provide an account to use on the Eglide shell hosting project servers.
    members:
      - aceppaluni
      - adrien
      - akoe
      - alinap
      - amine
      - amj
      - ariel
      - axe
      - balaji
      - bogani
      - c2c
      - chan
      - dereckson
      - dorianwinty
      - duranzed
      - erol
      - fauve
      - fluo
      - harshcrop
      - hlp
      - ieli
      - kazuya
      - khmerboy
      - kumkum
      - mous
      - pkuz
      - ptdradmin
      - rama
      - rashk0
      - ringa
      - rix
      - sandlayth
      - sandrine
      - shark
      - thrx
      - tomjerr
      - vigilant
      - whoami
      - windu
      - xcombelle
      - xray
      - yousra

  chaton-dev:
    description: Manage Bonjour chaton service
    members:
      - hlp

  nasqueron-irc:
    description: Manage IRC bots used for Nasqueron projects
    members:
      - dereckson
      - sandlayth

  nasqueron-dev-docker:
    description: Docker development
    members:
      - dereckson
      - dorianwinty
      - duranzed
      - ptdradmin
      - sandlayth

  ops:
    title: Nasqueron Operations
    description: >
        Maintain the servers infrastructure. As such, members of this
        group have a root access everywhere.
    members:
      - dereckson
      - dorianwinty
      - duranzed
      - sandlayth
      - yousra

  deployment:
    title: Nasqueron Deployment
    description: >
        Build software to be installed on the servers.
        Deploy web sites and services files.
    members:
      - dereckson

  nasquenautes:
    title: Nasqueron servers users
    description: >
        Provide an account on Nasqueron development servers.
    members:
      - aceppaluni
      - amine
      - dereckson
      - duranzed
      - dorianwinty
      - fauve
      - fluo
      - ieli
      - mous
      - ptdradmin
      - rama
      - sandlayth
      - sandrine
      - xcombelle
      - yousra
