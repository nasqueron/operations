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
      - dbserver-mysql
    zfs:
      pool: arcology
    network:
      ipv4_interface: igb0
      ipv4_address: 163.172.49.16
      ipv4_gateway: 163.172.49.1
      ipv6_gateway: 2001:470:1f12:9e1::1
      ipv4_aliases:
        - 212.83.187.132
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
