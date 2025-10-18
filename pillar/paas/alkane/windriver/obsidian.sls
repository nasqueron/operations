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
    db:
      service: db-B
      credentials: dbserver/cluster-B/users/obsidian51
    extra_values:
      DB_NAME: obsidian51
