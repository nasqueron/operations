#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Images
#
#   You can append a :tag (by default, latest is used).
#
#   It's not possible to specify Docker library images only by final name.
#   See https://docs.saltstack.com/en/latest/ref/states/all/salt.states.docker_image.html
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_images:
  - certbot/certbot

  # Core service
  - nasqueron/mysql:5.7

  # Continuous deployment jobs
  - jenkins/jenkins
  - nasqueron/jenkins-agent-php

#   -------------------------------------------------------------
#   Networks
#
#   Containers can be grouped by network, instead to use links.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_networks:
  bugzilla:
    subnet: 172.21.3.0/24
  jenkinsTest:
    subnet: 172.21.5.0/24

#   -------------------------------------------------------------
#   Docker engine configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_daemon:
  data-root: /srv/docker
  group: nasqueron-dev-docker

#   -------------------------------------------------------------
#   Containers
#
#   The docker_containers entry allow to declare
#   containers by image by servers
#
#   The hierarchy is so as following.
#
#   docker_containers:
#     service codename:
#       instance name:
#          container properties
#
#   The service codename must match a state file in
#   the roles/paas-docker/containers/ directory.
#
#   The container will be run with the specified instance name.
#
#   **nginx**
#
#   The container properties can also describe the information
#   needed to configure nginx with the host and app_port key.
#
#   In such case, a matching vhost file should be declared as
#   roles/paas-docker/nginx/files/vhosts/<service codename>.sls
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_containers:

  #
  # Core services
  #

  mysql:
    bugzilla_db:
      network: bugzilla
      version: 5.7
      credentials:
        root: espacewin.bugzilla.mysql_root

  #
  # Bugzilla
  #

  bugzilla:
    ew_bugzilla:
      host: bugzilla.espace-win.org
      app_port: 33080
      network: bugzilla
      mysql:
        host: bugzilla_db
        db: EspaceWin_Bugs
      credential: espacewin.bugzilla.mysql

  #
  # Jenkins
  #

  jenkins:
    jenkins_test:
      realm: test
      host: jenkins.test.nasqueron.org
      app_port: 47080
      jnlp_port: 52000

  jenkins_agent:
    zosso:
      image_flavour: php
      realm: test

  #
  # Mastodon
  #

  # Mastodon is currently deployed manually through docker-compose
  # and not yet integrated to the platform. This declaration is
  # currently only used for extra utilities deployment.

  mastodon_sidekiq:
    mastodon_sidekiq_1:
      realm: nasqueron
