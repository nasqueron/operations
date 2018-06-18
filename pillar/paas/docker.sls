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
    - nasqueron/mysql
    - nasqueron/rabbitmq
    # Infrastructure and development services
    - nasqueron/aphlict
    - dereckson/cachet
    - nasqueron/etherpad
    - nasqueron/notifications
    - nasqueron/phabricator
  equatower:
    # Continuous deployment jobs
    - jenkinsci/jenkins
    - nasqueron/jenkins-slave-php
    # phpBB SaaS
    -  nasqueron/mysql

docker_containers:
   equatower:
     # CD
     jenkins:
       host: cd.nasqueron.org
       app_port: 38080
     jenkins_slave:
       apsile:
         ip: 172.17.0.100
       elapsi:
         ip: 172.17.0.101

     # phpBB SaaS
     phpbb_db: {}

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
