#   -------------------------------------------------------------
#   Salt — PaaS Alkane :: PHP and static sites [development]
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Site:           https://drive.nasqueron.org/
#   -------------------------------------------------------------

web_aliases:
  services:
    - &db-B 172.27.27.9

#   -------------------------------------------------------------
#   PHP sites
#
#   Username must be unique and use max 31 characters.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_php_sites:
  drive.nasqueron.org:
    domain: nasqueron.org
    subdomain: drive
    user: web-org-nasqueron-drive
    php-fpm: prod
    php_flags:
      opcache.save_comments: on
      opcache.validate_timestamp: off
    php_values:
      opcache.jit: 1255
      opcache.jit_buffer_size: 128M

    env:
      DB_HOST: *db-B
      DB_NAME: nextcloud_windriver

      # Per NextCloud documentation
      HOSTNAME: $HOSTNAME
      PATH: /usr/local/bin:/usr/bin:/bin
      TMP: /tmp
      TMPDIR: /tmp
      TEMP: /tmp
