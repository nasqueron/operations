#   -------------------------------------------------------------
#   Salt — PaaS Alkane :: PHP and static sites [development]
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Site:           https://explore.wolfplex.org/
#   -------------------------------------------------------------

web_aliases:
  services:
    - &db-b 172.27.27.9

#   -------------------------------------------------------------
#   PHP sites
#
#   Username must be unique and use max 31 characters.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_php_sites:
  explore.wolfplex.org:
    domain: wolfplex.org
    subdomain: explore
    user: web-org-wolfplex-zine
    php-fpm: prod
    env:
      DB_HOST: *db-b
      DB_NAME: wolfplex_zine
