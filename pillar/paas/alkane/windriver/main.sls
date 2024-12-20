#   -------------------------------------------------------------
#   Salt — PaaS Alkane :: PHP and static sites [development]
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
    - hypership.space

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
  nasqueron.org:
    - docker51
    - packages
    - rain51
    - www51

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
  # Nasqueron
  tools51.nasqueron.org:
    domain: nasqueron.org
    subdomain: tools51
    user: web-org-nasqueron-tools51
    php-fpm: prod

  # Nasqueron members
  mediawiki.dereckson.be:
    domain: dereckson.be
    subdomain: mediawiki
    user: web-be-dereckson-mw
    php-fpm: prod

  www51.dereckson.be:
    domain: dereckson.be
    subdomain: www51
    user: web-be-dereckson-www51
    php-fpm: prod

  # Zed
  zed51.dereckson.be:
    domain: dereckson.be
    subdomain: zed51
    user: web-be-dereckson-zed51
    php-fpm: prod
    env:
      CACHE_DIR: /var/dataroot/zed/cache
      CONTENT_DIR: /var/dataroot/zed/content

  # Espace Win
  www51.espace-win.org:
    domain: espace-win.org
    subdomain: www51
    user: web-org-espacewin-www51
    php-fpm: prod

#   -------------------------------------------------------------
#   nginx configuration
#
#   Configuration files to provision to vhosts/
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nginx_vhosts:
  dereckson.be:
    - mediawiki
    - scherzo
    - www51
    - zed51

  espace-win.org:
    - grip

  nasqueron.org:
    - api51
    - grafana
    - packages
    - tools51
    - www51


#   -------------------------------------------------------------
#   Credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

webserver_content_dotenv:
  /var/51-wwwroot/dereckson-www/.env:
    user: web-be-dereckson-www51
    db:
      service: db-B
      credentials: dbserver/cluster-B/users/dereckson_www51
