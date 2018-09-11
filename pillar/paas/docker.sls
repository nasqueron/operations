#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

docker_aliases:
  - &ipv4_equatower 51.255.124.10

#   -------------------------------------------------------------
#   Images and containers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# You can append a :tag (by default, latest is used).
# You can't directly specify a Docker library images.
# See https://docs.saltstack.com/en/latest/ref/states/all/salt.states.docker_image.html

docker_images:
  '*':
    - certbot/certbot
  dwellers:
    # Core services
    - nasqueron/rabbitmq
    # Infrastructure and development services
    - dereckson/cachet
    - nasqueron/notifications
  equatower:
    # Core services
    - nasqueron/mysql
    # Infrastructure and development services
    - nasqueron/aphlict
    - nasqueron/etherpad
    - nasqueron/phabricator
    # Continuous deployment jobs
    - jenkinsci/jenkins
    - nasqueron/jenkins-slave-php
    # phpBB SaaS
    -  nasqueron/mysql

docker_containers:
   equatower:
     # MySQL
     mysql:
      acquisitariat: {}
      phpbb_db: {}

     # CD
     jenkins:
       host: cd.nasqueron.org
       app_port: 38080
     jenkins_slave:
       apsile:
         ip: 172.17.0.100
       elapsi:
         ip: 172.17.0.101

     # Infrastructure and development services
     phabricator:
       devcentral: {}
     aphlict: {}
     cachet:
       app_port: 39080
       host: status.nasqueron.org
       mysql_link: acquisitariat
     etherpad:
       app_port: 34080
       host: pad.nasqueron.org
       aliases:
         - pad.wolfplex.org
         - pad.wolfplex.be
       mysql_link: acquisitariat
       plugins:
         - ep_ether-o-meter
         - ep_author_neat

     # phpBB SaaS
     # The SaaS uses a MySQL instance, declared in the MySQL section.

     # Openfire
     openfire:
       ip: *ipv4_equatower
       app_port: 9090
       host: xmpp.nasqueron.org

 #   -------------------------------------------------------------
 #   Ports listened by XMPP
 #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

xmpp_ports:
  - 3478
  - 5222 # Client to server
  - 5223 # Client to server (Encrypted (legacy-mode) connections)
  - 5262 # Connections managers
  - 5269 # Server to server
  - 5275 # External components
  - 5276 # External components (Encrypted (legacy-mode) connections)
  - 7070 # HTTP binding
  - 7443 # HTTP binding with TLS
  - 7777 # File transfer proxy
  - 9090 # Web administration server
  - 9091 # Web administration server with TLS

 #   -------------------------------------------------------------
 #   Zemke-Rhyne clients
 #
 #   This section should list all the Docker engines server
 #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

zr_clients:
  - key: 2
    allowedConnectionFrom:
      - 172.27.26.49
      - dwellers.nasqueron.drake
      - dwellers.nasqueron.org
    restrictCommand:
    comment: Zemke-Rhyne
  - key: 123
    allowedConnectionFrom:
      - equatower.nasqueron.org
    restrictCommand:
    comment: Zemke-Rhyne
