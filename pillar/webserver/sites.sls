#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Domains we deploy
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_domains:

  #
  # Directly managed by Nasqueron
  #

  nasqueron:
    - nasqueron.org

  #
  # Nasqueron members
  #

  nasqueron_members:
    - dereckson.be

  #
  # Projects ICT is managed by Nasqueron
  #

  espacewin:
    - espace-win.org

  wolfplex:
    - wolfplex.org

#   -------------------------------------------------------------
#   Static sites
#
#   Sites to deploy from the staging repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_static_sites:
  dereckson.be:
    - assets
  nasqueron.org:
    - www
    - assets
    - docker
    - ftp
    - launch
    - packages
    - trustspace
  wolfplex.org:
    - www
    - assets

#   -------------------------------------------------------------
#   PHP sites
#
#   Username must be unique and use max 31 characters.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

php_custom_builds:
  php56:
    mode: release
    version: 5.6.40
    hash: ffd025d34623553ab2f7fd8fb21d0c9e6f9fa30dc565ca03a1d7b763023fba00

php_fpm_instances:
  # PHP 7.2, generally installed as package/port
  prod:
    command: /usr/local/sbin/php-fpm

  # PHP 5.6, installed through php-builder unit
  legacy:
    command: /opt/php/php56/sbin/php-fpm

web_php_sites:
  # Nasqueron members
  mediawiki.dereckson.be:
    domain: dereckson.be
    subdomain: mediawiki
    user: web-be-dereckson-mw
    php-fpm: prod

  www.dereckson.be:
    domain: dereckson.be
    subdomain: www
    user: web-be-dereckson-www
    source: wwwroot/dereckson.be/www
    target: /var/wwwroot/dereckson.be/www
    php-fpm: prod

  www51.dereckson.be:
    domain: dereckson.be
    subdomain: www51
    user: web-be-dereckson-www51
    php-fpm: prod

  # Directly managed by Nasqueron
  api.nasqueron.org:
    domain: nasqueron.org
    subdomain: api
    user: web-org-nasqueron-api-serverslog
    php-fpm: prod
    env:
      SERVERS_LOG_FILE: /srv/api/data/servers-log-all.json

  wikis.nasqueron.org:
    domain: nasqueron.org
    subdomain: wikis
    user: mediawiki
    php-fpm: prod
    skipCreateAccount: True
    env:
      MEDIAWIKI_ENTRY_POINT: /srv/mediawiki/index.php
      DB_HOST: localhost
      DB_USER: mediawiki-saas

  # Espace Win
  www.espace-win.org:
    domain: espace-win.org
    subdomain: www
    user: web-org-espacewin-www
    source: wwwroot/espace-win.org/www
    target: /var/wwwroot/espace-win.org/www
    php-fpm: legacy

  www51.espace-win.org:
    domain: espace-win.org
    subdomain: www51
    user: web-org-espacewin-www51
    php-fpm: prod

  # Wolfplex Hackerspace
  www.wolfplex.org:
    domain: wolfplex.org
    subdomain: www
    user: web-org-wolfplex-www
    php-fpm: prod
    env:
      DATASTORE: /var/dataroot/wolfplex
      CREDENTIAL_PATH_DATASOURCES_SECURITYDATA: /var/dataroot/wolfplex/secrets.json

#   -------------------------------------------------------------
#   States
#
#   Sites with states documenting how to build them
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_content_sls:
  #
  # Eglide
  #
  shellserver:
    # Third party sites hosted to Eglide
    - .com/paysannerebelle

    # Directly managed by Eglide project
    - .org/eglide

  #
  # Nasqueron servers
  #
  mastodon:
    - .org/nasqueron/social

  webserver-legacy:
    # Nasqueron members
    - .be/dereckson

    # Projects hosted
    - .space/hypership

    # Directly managed by Nasqueron
    - .org/nasqueron/api
    - .org/nasqueron/daeghrefn
    - .org/nasqueron/docs
    - .org/nasqueron/infra
    - .org/nasqueron/labs
    - .org/nasqueron/rain

    # Wolfplex Hackerspace
    - .org/wolfplex/api
    - .org/wolfplex/www

#   -------------------------------------------------------------
#   Tweaks
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_autochmod:
  - /var/wwwroot/dereckson.be/www
