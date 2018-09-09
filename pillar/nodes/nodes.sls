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
    forest: nasqueron-infra
    hostname: dwellers.nasqueron.org
    roles:
      - paas-lxc
      - paas-docker
      - mastodon
    network:
      ipv6_tunnel: True
  equatower:
    forest: nasqueron-infra
    hostname: equatower.nasqueron.org
    roles:
      - paas-docker
    network:
      ipv4_address: 51.255.124.10
      ipv4_gateway: 91.121.86.254
      ipv6_tunnel: False
  ysul:
    forest: nasqueron-dev
    hostname: ysul.nasqueron.org
    roles:
      - devserver
      - saltmaster
      - dbserver-mysql
      - webserver-legacy
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
  ## between Eglide and Nasqueron servers.
  ##
  eglide:
    forest: eglide
    hostname: eglide.org
    roles:
      - shellserver
    network:
      ipv6_tunnel: True
    fixes:
      rsyslog_xconsole: True
