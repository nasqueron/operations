#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Service:        Openfire XMPP server
#   -------------------------------------------------------------

docker_aliases:
  - &ipv4_docker002 51.255.124.9
  - &ipv4_docker002_restricted 172.27.27.5

docker_images:
  - nasqueron/openfire

docker_containers:
  # Openfire
  openfire:
    openfire:
      ip: *ipv4_docker002
      app_port: 9090
      host: xmpp.nasqueron.org

      # Other subservices for XMPP
      # listening to their own subdomain
      aliases:
        - conference.nasqueron.org

 #   -------------------------------------------------------------
 #   Ports listened
 #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

xmpp_ports:
  - 3478 # VoIP STUN (Session Traversal Utilities for NAT)
  - 5222 # Client to server
  - 5223 # Client to server (Encrypted (legacy-mode) connections)
  - 5229 # Flash Cross Domain
  - 5262 # Connections managers
  - 5269 # Server to server
  - 5270 # Server to server (Encrypted (legacy-mode) connections)
  - 5275 # External components
  - 5276 # External components (Encrypted (legacy-mode) connections)
  - 7070 # HTTP binding
  - 7443 # HTTP binding with TLS
  - 7777 # File transfer proxy
  - 9090 # Web administration server
  - 9091 # Web administration server with TLS
