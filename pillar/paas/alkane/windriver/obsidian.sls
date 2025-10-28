#   -------------------------------------------------------------
#   Salt — PaaS Alkane :: PHP and static sites [development]
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Site:           https://obsidian51.nasqueron.org
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   PHP sites
#
#   Username must be unique and use max 31 characters.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_php_sites:
  obsidian51.nasqueron.org:
    domain: nasqueron.org
    subdomain: obsidian51
    user: web-org-nasqueron-obsidian51
    php-fpm: prod

#   -------------------------------------------------------------
#   Vhosts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nginx_vhosts:
  nasqueron.org:
    - obsidian51

#   -------------------------------------------------------------
#   .env configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

webserver_content_dotenv:
  /var/51-wwwroot/obsidian/.env:
    user: web-org-nasqueron-obsidian51
    databases:
      - service: db-B
        credentials: dbserver/cluster-B/users/obsidian51
      - service: db-A
        credentials: dbserver/cluster-A/users/obsidian
        prefix: ORBEON_
    extra_values:
      DB_NAME: obsidian51
