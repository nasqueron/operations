#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

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
    - nasqueron/aphlict
    - dereckson/cachet
    - nasqueron/notifications
    - nasqueron/phabricator
  equatower:
    # Core services
    - nasqueron/mysql
    # Infrastructure and development services
    - nasqueron/etherpad
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
     etherpad:
       app_port: 34080
       mysql_link: acquisitariat
       plugins:
         - ep_ether-o-meter
         - ep_author_neat

     # phpBB SaaS
     # The SaaS uses a MySQL instance, declared in the MySQL section.

     # Openfire
     openfire:
       host: xmpp.nasqueron.org

 #   -------------------------------------------------------------
 #   Ports listened by XMPP
 #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

xmpp_ports:
  - 3478
  - 5222 # Client to server
  - 5223 # Client to server (Encrypted (legacy-mode) connections)
  - 5262 # Cnnections managers
  - 5269 # Server to server
  - 5275 # External components
  - 5276 # External components (Encrypted (legacy-mode) connections)
  - 7070 # HTTP binding
  - 7443 # HTTP binding with TLS
  - 7777 # File transfer proxy
  - 9090 # Web administration server
  - 9091 # Web administration server with THLS
