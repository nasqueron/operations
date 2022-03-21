networks:
  drake:
    cidr: 172.27.27.0/24
    netmask: 255.255.255.0

    # router-001 acts as a gateway for all nodes
    # For GRE tunnels, gateway is probably the tunnel endpoint
    # The other nodes can use the default_gateway IP.
    router: router-001
    default_gateway: 172.27.27.1

#   -------------------------------------------------------------
#   Drake - GRE tunnels
#
#   Describe GRE tunnels between a node and {networks.drake.router}
#
#   {id}:
#   router:
#       interface: gre0, gre1, ... / increment for each tunnel
#       addr:      The tunnel IPv4 on the router in 172.27.27.240/28
#
#     node:
#       interface: Not needed on Linux as the interface name will be
#                  descriptive: gre-drake_via_{networks.drake.router}
#
#                  Not needed on FreeBSD if default value "gre0" is fine.
#                  If there is several GRE tunnels, can be gre1, gre2, etc.
#
#       addr:      The canonical IPv4 for the server in 172.27.27.0/24
#
#   IP should be sync between the pillar and the Operations grimoire
#   at https://agora.nasqueron.org/Operations_grimoire/Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

drake_gre_tunnels:
  ysul:
    router:
      interface: gre0
      addr: 172.27.27.252
    node:
      addr: 172.27.27.33

  cloudhugger:
    router:
      interface: gre1
      addr: 172.27.27.253
    node:
      addr: 172.27.27.28

  windriver:
    router:
      interface: gre2
      addr: 172.27.27.254
    node:
      addr: 172.27.27.35
