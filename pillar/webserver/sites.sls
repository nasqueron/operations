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
  # Wolfplex
  #
  wolfplex:
    - wolfplex.org

#   -------------------------------------------------------------
#   Static sites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_static_sites:
  nasqueron.org:
    - www
    - assets
    - docker
    - ftp
    - infra
    - packages
    - trustspace
  wolfplex.org:
    - www

#   -------------------------------------------------------------
#   PHP sites
#
#   Username must be unique and use max 31 characters.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

php_fpm_instances:
  # PHP 7.2, generally installed as package/port
  prod:
    command: /usr/local/sbin/php-fpm

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
      DB_HOST: 127.0.0.1
      DB_USER: mediawiki-saas

  # Wolfplex Hackerspace
  www.wolfplex.org:
    domain: wolfplex.org
    subdomain: www
    user: web-org-wolfplex-www
    php-fpm: prod
    env:
      DATASTORE: /var/dataroot/wolfplex

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

    # Directly managed by Nasqueron
    - .org/nasqueron/api
    - .org/nasqueron/docs
    - .org/nasqueron/labs

    # Wolfplex Hackerspace
    - .org/wolfplex/www

#   -------------------------------------------------------------
#   Tweaks
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_autochmod:
  - /var/wwwroot/dereckson.be/www
