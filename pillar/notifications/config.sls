#   -------------------------------------------------------------
#   Notifications center
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Credentials
#
#   The secret key value is the Vault key path for this secret,
#   it will be passed to the credentials.get_token method.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

notifications_credentials:
  services:

    # Nasqueron

    - gate: GitHub
      door: Nasqueron
      secret: nasqueron/notifications/credentials/github/nasqueron

    - gate: GitHub
      door: Wolfplex
      secret: nasqueron/notifications/credentials/github/wolfplex

    - gate: GitHub
      door: Keruald
      secret: nasqueron/notifications/credentials/github/keruald

    - gate: GitHub
      door: TrustSpace
      secret: nasqueron/notifications/credentials/github/trustspace

    - gate: GitHub
      door: Eglide
      secret: nasqueron/notifications/credentials/github/eglide

    - gate: Phabricator
      door: Nasqueron
      instance: https://devcentral.nasqueron.org
      secret: nasqueron/notifications/credentials/phabricator/nasqueron

#   -------------------------------------------------------------
#   Docker Hub build triggers
#
#   Key: the repository, the same in GitHub and Docker Hub
#   Value: the *full* path to Vault secret
#
#   This vault secret should use the following format:
#     source: the UUID after /source/
#     trigger: the UUID after /trigger/
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

notifications_dockerhub_triggers:
  nasqueron/auth-grove: apps/notifications-center/dockerhub/auth-grove
  nasqueron/notifications: apps/notifications-center/dockerhub/notifications

#   -------------------------------------------------------------
#   Payload analyzer configuration
#
#   The content of notifications_configuration will be split
#   into folders and JSON files, converted from YAML objects.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

notifications_configuration:
  GitHubPayloadAnalyzer:
    default: &default
      administrativeGroup: orgz
      defaultGroup: ''
      map: []

    Nasqueron:
      administrativeGroup: orgz
      defaultGroup: nasqueron
      map:
        - group: docker
          items:
            - docker-*

        - group: tasacora
          items:
            - tasacora-*

        - group: devtools
          items:
            - notifications
            - notifications-cli-client

        - group: ops
          items:
            - decommission
            - discourse-config
            - ftp
            - operations
            - servers-*
            - zemke-rhyne

  JenkinsPayloadAnalyzer:
    default:
      defaultGroup: ci
      map: []
      notifyOnlyOnFailure: []

    Nasqueron:
      defaultGroup: ci
      map:
        - group: wikidata
          items:
            - deploy-irc-daeghrefn-wikidata

        - group: ops
          items:
            - deploy-website-*
            - test-prod-env

        - group: devtools
          items:
            - test-notifications-*

      notifyOnlyOnFailure:
        - test-prod-env

  PhabricatorPayloadAnalyzer:
    default: *default

    Nasqueron:
      administrativeGroup: orgz
      defaultGroup: nasqueron
      map:
        - group: docker
          items:
            - Docker images
            - Nasqueron Docker deployment squad
          words:
            - Docker

        - group: tasacora
          items:
            - Tasacora
          words:
            - Tasacora
            - cartography

        - group: trustspace
          items:
            - TrustSpace

        - group: ops
          items:
            - Continous integration and delivery
            - Drake network
            - IPv6
            - Mail
            - Message queues
            - Murasil
            - Nasqueron security operations squad
            - Secure HA tunnels
            - Servers
            - Ops-sprint-*
            - Salt
          words:
            - Ysul
            - Dwellers
            - Eglide
            - pkg audit
          wordsAreStrong: true
