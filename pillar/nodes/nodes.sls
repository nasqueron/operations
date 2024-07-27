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
      ipv6_tunnel: False

      canonical_public_ipv4: 188.165.200.229

      interfaces:
        eno1:
          device: eno1
          ipv4:
            address: 188.165.200.229
            netmask: 255.255.255.0
            gateway: 188.165.200.254
          ipv6:
            address: fe80::ec4:7aff:fe6a:36e8
            prefix: 64
            gateway: fe80::ee30:91ff:fee0:df80

  complector:
    forest: nasqueron-infra
    hostname: complector.nasqueron.org
    roles:
      - vault
      - salt-primary
    zfs:
      pool: zroot
    network:
      ipv6_tunnel: False

      interfaces:
        intranought:
          device: vmx0
          ipv4:
            address: 172.27.27.7
            netmask: *intranought_netmask
            gateway: 172.27.27.1

  db-A-001:
    forest: nasqueron-infra
    hostname: db-A-001.nasqueron.drake
    roles:
      - dbserver-pgsql
    zfs:
      pool: arcology
    dbserver:
      cluster: A
    network:
      ipv6_tunnel: False

      interfaces:
        intranought:
          device: vmx0
          ipv4:
            address: 172.27.27.8
            netmask: *intranought_netmask
            gateway: 172.27.27.1

  db-B-001:
    forest: nasqueron-infra
    hostname: db-B-001.nasqueron.drake
    roles:
      - dbserver-mysql
    zfs:
      pool: arcology
    dbserver:
      cluster: B
    network:
      ipv6_tunnel: False

      interfaces:
        intranought:
          device: vmx0
          ipv4:
            address: 172.27.27.9
            netmask: *intranought_netmask
            gateway: 172.27.27.1

  dwellers:
    forest: nasqueron-dev-docker
    hostname: dwellers.nasqueron.org
    roles:
      - paas-lxc
      - paas-docker
      - paas-docker-dev
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
            netmask: *intranought_netmask
            gateway: 51.210.99.254

        intranought:
          device: ens224
          uuid: 8e8ca793-b2eb-46d8-9266-125aba6d06c4
          ipv4:
            address: 172.27.27.4
            netmask: *intranought_netmask
            gateway: 172.27.27.1

  docker-002:
    forest: nasqueron-infra
    hostname: docker-002.nasqueron.org
    roles:
      - paas-docker
      - paas-docker-prod
    network:
      ipv6_tunnel: True

      canonical_public_ipv4: 51.255.124.9

      interfaces:
        public:
          device: ens192
          uuid: d55e0fec-f90b-3014-a458-9067ff8f2520
          ipv4:
            address: 51.255.124.10
            netmask: *intranought_netmask
            gateway: 51.210.99.254

        intranought:
          device: ens224
          uuid: 57c04bcc-929b-3177-a2e3-88f84f210721
          ipv4:
            address: 172.27.27.5
            netmask: *intranought_netmask
            gateway: 172.27.27.1

  hervil:
    forest: nasqueron-infra
    hostname: hervil.nasqueron.drake
    network:
      interfaces:
        vmx0:
          device: vmx0
          ipv4:
            address: 172.27.27.3
            netmask: *intranought_netmask
            gateway: 172.27.27.1
        vmx1:
          device: vmx1
          ipv4:
            address: 178.32.70.108
            netmask: 255.255.255.255
    roles:
      - mailserver
      - webserver-core
      - webserver-alkane

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
            netmask: *intranought_netmask
            gateway: 51.210.99.254
          ipv6:
            address: 2001:41d0:303:d971::6a7e
            gateway: 2001:41d0:303:d9ff:ff:ff:ff:ff
            prefix: 64
          flags:
            - ipv4_ovh_failover

        intranought:
          device: vmx1
          ipv4:
            address: 172.27.27.1
            netmask: *intranought_netmask

  web-001:
    forest: nasqueron-infra
    hostname: web-001.nasqueron.org
    roles:
      - webserver-alkane
      - webserver-alkane-prod
      - saas-mediawiki
      - saas-wordpress
    network:
      ipv6_tunnel: False

      canonical_public_ipv4: 51.255.124.10

      interfaces:
        intranought:
          device: vmx0
          ipv4:
            address: 172.27.27.10
            netmask: *intranought_netmask
            gateway: 172.27.27.1

        public:
          device: vmx1
          ipv4:
            address: 51.255.124.10
            netmask: 255.255.255.255
            gateway: 51.210.99.254
          ipv6:
            address: 2001:41d0:303:d971::517e:c0de
            gateway: 2001:41d0:303:d9ff:ff:ff:ff:ff
            prefix: 64

    fixes:
      hello_ipv6_ovh: True

  ysul:
    forest: nasqueron-dev
    hostname: ysul.nasqueron.org
    roles:
      - devserver
      - dbserver-mysql
      - viperserv
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
            netmask: 255.255.255.0
            gateway: 163.172.49.1
            aliases:
              - 212.83.187.132

  windriver:
    forest: nasqueron-dev
    hostname: windriver.nasqueron.org
    roles:
      - devserver
      - dbserver-mysql
      - webserver-alkane
      - webserver-alkane-dev
      - webserver-legacy
    zfs:
      pool: arcology
    network:
      ipv6_tunnel: False

      canonical_public_ipv4: 51.159.17.168

      interfaces:
        igb0:
          device: igb0
          ipv4:
            address: 51.159.17.168
            netmask: 255.255.255.0
            gateway: 51.159.17.1
          ipv6:
            address: 2001:bc8:2e84:700::da7a:7001
            gateway: fe80::2616:9dff:fe9c:c521
            prefix: 56
          flags:
            - ipv6_dhcp_duid

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
