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

  nasqueron.org:
    - api51
    - tools51
    - www51
