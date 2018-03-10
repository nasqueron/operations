#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

# You can append a :tag (by default, latest is used).
# You can't directly specify a Docker library images.
# See https://docs.saltstack.com/en/latest/ref/states/all/salt.states.docker_image.html

docker_images:
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
    # Continous deployment jobs
    - jenkinsci/jenkins
    - nasqueron/jenkins-slave-php
