#   -------------------------------------------------------------
#   Salt — PaaS Alkane :: PHP and static sites [production]
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   nginx, php-fpm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_domains:
  zed:
    - hypership.space

nginx_vhosts:
  hypership.space:
    - www

web_php_sites:
  hypership.space:
    domain: hypership.space
    subdomain: www
    user: web-space-hypership-www
    php-fpm: prod
    env:
      CACHE_DIR: /var/dataroot/zed/cache
      CONTENT_DIR: /var/dataroot/zed/content

#   -------------------------------------------------------------
#   Credentials
#
#     :: deployment
#     :: .env
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

wwwroot_identities:
  deploy-key-github-hypership-content_users:
    secret: nasqueron/deploy/deploy_keys/by_repo/github/hypership/content_users
    path: /opt/salt/security/id_zed_github_hypership_content_users

webserver_content_dotenv:
  /var/wwwroot/hypership.space/www/.env:
    user: web-space-hypership-www
    databases:
      - service: db-B
        credentials: dbserver/cluster-B/users/zed
    extra_values:
      DB_NAME: zed_prod
    extra_credentials:
      ZED_SECRET_KEY: zed/hypership/secret_key
