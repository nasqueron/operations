#   -------------------------------------------------------------
#   Notifications center
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-30
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

notifications_credentials:
  services:

    # Nasqueron

    - gate: GitHub
      door: Nasqueron
      secret: {{ salt['zr.get_token'](153) }}

    - gate: GitHub
      door: Wolfplex
      secret: {{ salt['zr.get_token'](156) }}

    - gate: GitHub
      door: Keruald
      secret: {{ salt['zr.get_token'](157) }}

    - gate: GitHub
      door: TrustSpace
      secret: {{ salt['zr.get_token'](158) }}

    - gate: GitHub
      door: Eglide
      secret: {{ salt['zr.get_token'](159) }}

    - gate: Phabricator
      door: Nasqueron
      instance: https://devcentral.nasqueron.org
      secret: {{ salt['zr.get_token'](154) }}
      api_token: {{ salt['zr.get_token'](155) }}

# Docker Hub build triggers URL can't currently been automated easily.

#   -------------------------------------------------------------
#   Payload analyzer configuration
#
#   The content of notifications_configuration will be split
#   into folders and JSON files, converted from YAML objects.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

notifications_configuration:
  GitHubPayloadAnalyzer:
    default: &default
      administrativeGroup: org
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
            - IPv6
            - Mail
            - Message queues
            - Murasil
            - Nasqueron security operations squad
            - Servers
            - Ops-sprint-*
            - Salt
          words:
            - Ysul
            - Dwellers
            - Eglide
            - pkg audit
          wordsAreStrong: true
