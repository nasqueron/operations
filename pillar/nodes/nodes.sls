#   -------------------------------------------------------------
#   Salt — Nodes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

nodes_aliases:
  netmasks:
    intranought: &intranought_netmask 255.255.255.240

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
      ipv6_native: True
      ipv6_tunnel: False

      canonical_public_ipv4: 188.165.200.229

      interfaces:
        eno1:
          device: eno1
          ipv4:
            address: 188.165.200.229
            gateway: 188.165.200.254
          ipv6:
            address: fe80::ec4:7aff:fe6a:36e8
            prefix: 64
            gateway: fe80::ee30:91ff:fee0:df80

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
      ipv6_tunnel: True

      canonical_public_ipv4: 51.255.124.11

      interfaces:
        public:
          device: ens192
          uuid: 6e05ebea-f2fd-4ca1-a21f-78a778664d8c
          ipv4:
            address: 51.255.124.11
            netmask: 255.255.255.252
            gateway: 91.121.86.254

        intranought:
          device: ens224
          uuid: 8e8ca793-b2eb-46d8-9266-125aba6d06c4
          ipv4:
            address: 172.27.27.4
            netmask: *intranought_netmask
            gateway: 172.27.27.1

  docker-001:
    forest: nasqueron-infra
    hostname: docker-001.nasqueron.org
    roles:
      - paas-docker
    network:
      ipv6_tunnel: False

      canonical_public_ipv4: 51.255.124.9

      interfaces:
        public:
          device: ens192
          uuid: ef7370c5-5060-4d89-82bb-dbeabf4a35f6
          ipv4:
            address: 51.255.124.9
            netmask: 255.255.255.252
            gateway: 91.121.86.254

        intranought:
          device: ens224
          uuid: 3fd0b9f8-ecc3-400d-bc61-3ba21d0b6337
          ipv4:
            address: 172.27.27.6
            netmask: *intranought_netmask
            gateway: 172.27.27.1

  router-001:
    forest: nasqueron-infra
    hostname: router-001.nasqueron.org
    roles:
      - router
    network:
      ipv6_tunnel: False

      canonical_public_ipv4: 51.255.124.8

      interfaces:
        public:
          device: vmx0
          ipv4:
            address: 51.255.124.8
            netmask: 255.255.255.252
            gateway: 91.121.86.254
          flags:
            - ipv4_ovh_failover

        intranought:
          device: vmx1
          ipv4:
            address: 172.27.27.1
            netmask: *intranought_netmask

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
      ipv6_tunnel: True
      ipv6_gateway: 2001:470:1f12:9e1::1

      canonical_public_ipv4: 212.83.187.132

      interfaces:
        igb0:
          device: igb0
          ipv4:
            address: 163.172.49.16
            netmask: 255.255.255.255
            gateway: 163.172.49.1
            aliases:
              - 212.83.187.132

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
      ipv6_native: True
      ipv6_tunnel: False

      canonical_public_ipv4: 51.159.18.59

      interfaces:
        igb0:
          device: igb0
          ipv4:
            address: 51.159.18.59
            netmask: 255.255.255.255
            gateway: 51.159.18.1
          ipv6:
            address: 2001:0bc8:6005:0005:aa1e:84ff:fef3:5d9c
            gateway: fe80::a293:51ff:feb7:5073
            prefix: 128

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

      canonical_public_ipv4: 51.159.150.221

      interfaces:
        ens2:
          device: ens2
          ipv4:
            address: 51.159.150.221
            gateway: ""
          flags:
            # This interface is configured by cloud-init
            - skip_interface_configuration

    fixes:
      rsyslog_xconsole: True
