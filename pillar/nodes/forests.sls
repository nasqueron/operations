#   -------------------------------------------------------------
#   Salt — Forests
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   Description:    Groups nodes by forest to allow to apply
#                   a common configuration, like users/groups
#                   to a set of nodes (ie servers).
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Table of contents
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#   :: Forests
#   :: Shell groups
#
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Forests
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

forests:
  - nasqueron-dev
  - nasqueron-infra
  - eglide

#   -------------------------------------------------------------
#   Shell groups
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

shellgroups_ubiquity:
  - ops
  - deployment

shellgroups_by_forest:
  nasqueron-dev:
    - nasquenautes
    - nasqueron-irc

  nasqueron-infra: []

  eglide:
    - shell
    - chaton-dev
    - nasqueron-irc
