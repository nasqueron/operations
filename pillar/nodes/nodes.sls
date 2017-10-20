#   -------------------------------------------------------------
#   Salt — Nodes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

nodes:
  ##
  ## Forest:         Nasqueron
  ## Semantic field: https://devcentral.nasqueron.org/P27
  ##
  dwellers:
    forest: nasqueron
    hostname: dwellers.nasqueron.org
    roles:
      - paas-lxc
      - paas-docker
    network:
      ipv6_tunnel: True
  equatower:
    forest: nasqueron
    hostname: equatower.nasqueron.org
    roles:
      - paas-docker
    network:
      ipv6_tunnel: False
  ysul:
    forest: nasqueron
    hostname: ysul.nasqueron.org
    roles:
      - devserver
      - saltmaster
    network:
      ipv6_tunnel: True
  ##
  ## Forest:         Eglide
  ## Semantic field: ? (P27 used for "Eglide" too)
  ##
  ## This forest is intended to separate credentials
  ## between Eglide and Nasqueron sevrers.
  ##
  eglide:
    forest: eglide
    hostname: eglide.org
    roles:
      - shellserver
    network:
      ipv6_tunnel: True
