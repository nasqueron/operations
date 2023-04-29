#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Content of the .env files
#
#   Those files allow site using DotEnv to read secrets.
#
#   To ensure secrets can only be read by application user, use:
#
#   ```
#   user: <php-fpm pool user>
#   ```
#   If your configuration can be read and stored in memory,
#   it's probably best to directly call Vault from the app
#   and only provision Vault AppRole credentials:
#
#   ```
#   vault: <path to AppRole credential>
#   ```
#
#   For PHP sites where the configuration file is read every
#   request, it's probably best to cache secrets in file
#   through this mechanism.
#
#   If you need a database, you can use:
#
#   ```
#   db:
#     service: entry in nasqueron_services table
#     credentials: path to Vault secret
#
#   To provision a secret key or other credentials, use:
#
#   extra_credentials:
#     key: path to vault secret
#
#   If you need to pass extra plain values use:
#
#   extra_values:
#     key: value
#   ```
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

webserver_content_dotenv:
  /var/wwwroot/dereckson.be/www/.env:
    user: web-be-dereckson-www
    db:
      service: db-B
      credentials: dbserver/cluster-B/users/dereckson_www

  /var/wwwroot/hypership.space/www/.env:
    user: web-space-hypership-www
    db:
      service: db-B
      credentials: dbserver/cluster-B/users/zed
    extra_credentials:
      ZED_SECRET_KEY: zed/hypership/secret_key
