#   -------------------------------------------------------------
#   Salt — PaaS Alkane :: PHP and static sites [production]
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

web_aliases:
  services:
    - &db-B 172.27.27.9

#   -------------------------------------------------------------
#   Domains we deploy
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_domains:

  #
  # Directly managed by Nasqueron
  #

  nasqueron:
    - nasqueron.org
    - ook.space

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

php_fpm_instances:
  # PHP current version, generally installed as package/port
  prod:
    command: /usr/local/sbin/php-fpm

web_php_sites:
  # Nasqueron members
  www.dereckson.be:
    domain: dereckson.be
    subdomain: www
    user: web-be-dereckson-www
    source: wwwroot/dereckson.be/www
    target: /var/wwwroot/dereckson.be/www
    php-fpm: prod
    capabilities:
      - wordpress

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
    skipCreateUser: True
    env:
      MEDIAWIKI_ENTRY_POINT: /srv/mediawiki/index.php
      DB_HOST: *db-B
      DB_USER: saas-mediawiki

  # Espace Win
  www.espace-win.org:
    domain: espace-win.org
    subdomain: www
    user: web-org-espacewin-www
    source: wwwroot/espace-win.org/www
    target: /var/wwwroot/espace-win.org/www
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
#   nginx configuration
#
#   Configuration files to provision to vhosts/
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nginx_vhosts:
  dereckson.be:
    - assets
    - hg
    - www

  espace-win.org:
    - cosmo
    - www

  nasqueron.org:
    - api
    - assets
    - autoconfig
    - daeghrefn
    - docker
    - docs
    - ftp
    - infra
    - join
    - labs
    - launch
    - packages
    - rain
    - trustspace
    - www

  test.ook.space:
    - migration.mediawiki

  wolfplex.org:
    - api
    - assets
    - www

#   -------------------------------------------------------------
#   Credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

webserver_content_dotenv:
  /var/wwwroot/dereckson.be/www/.env:
    user: web-be-dereckson-www
    db:
      service: db-B
      credentials: dbserver/cluster-B/users/dereckson_www

#   -------------------------------------------------------------
#   Alkane deployment recipes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alkane_recipes:
  www.nasqueron.org:
    init: standard-init.sh
    update: standard-update.sh
