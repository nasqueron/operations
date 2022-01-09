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

  cloudhugger:
    forest: nasqueron-infra
    hostname: cloudhugger.nasqueron.org
    roles:
      - opensearch
    network:
      ipv4_interface: eno1
      ipv4_address: 188.165.200.229
      ipv4_gateway: 188.165.200.254

      ipv6_interface: eno1
      ipv6_address: fe80::ec4:7aff:fe6a:36e8
      ipv6_gateway: fe80::ee30:91ff:fee0:df80
      ipv6_prefix: 64
      ipv6_native: True

      ipv6_tunnel: False

  dwellers:
    forest: nasqueron-infra
    hostname: dwellers.nasqueron.org
    roles:
      - paas-lxc
      - paas-docker
      - mastodon
    flags:
      install_docker_devel_tools: True
    network:
      ipv4_address: 51.255.124.11
      ipv4_gateway: 91.121.86.254

      ipv6_tunnel: True

  docker-001:
    forest: nasqueron-infra
    hostname: docker-001.nasqueron.org
    roles:
      - paas-docker
    network:
      ipv4_address: 51.255.124.9
      ipv4_gateway: 91.121.86.254

      ipv6_tunnel: False

  router-001:
    forest: nasqueron-infra
    hostname: router-001.nasqueron.org
    roles:
      - router
    network:
      ipv4_interface: vmx0
      ipv4_address: 51.255.124.8
      ipv4_netmask: 255.255.255.255
      ipv4_gateway: 91.121.86.254
      ipv4_ovh_failover: True

      private_interface: vmx1
      private_address: 172.27.27.1
      private_netmask: 255.255.255.0

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
      ipv4_aliases:
        - 212.83.187.132

      ipv6_tunnel: True
      ipv6_gateway: 2001:470:1f12:9e1::1

  windriver:
    forest: nasqueron-dev
    hostname: windriver.nasqueron.org
    roles:
      - devserver
      - saltmaster
      - dbserver-mysql
      - webserver-legacy
    zfs:
      pool: arcology
    network:
      ipv4_interface: igb0
      ipv4_address: 51.159.18.59
      ipv4_gateway: 51.159.18.1

      ipv6_interface: igb0
      ipv6_address: 2001:0bc8:6005:0005:aa1e:84ff:fef3:5d9c
      ipv6_gateway: fe80::a293:51ff:feb7:5073
      ipv6_prefix: 128
      ipv6_native: True

      ipv6_tunnel: False

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
      ipv4_interface: ens2
      ipv4_address: 51.159.150.221
      ipv4_gateway: ""

      ipv6_tunnel: True
    fixes:
      rsyslog_xconsole: True
