#   -------------------------------------------------------------
#   Salt — PaaS Alkane :: PHP and static sites [development]
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Site:           https://admin.mail.nasqueron.org/
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   PHP sites
#
#   Username must be unique and use max 31 characters.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_domains:
  nasqueron:
    - nasqueron.org

nginx_vhosts:
  nasqueron.org:
    - admin.mail
    - mail

php_fpm_instances:
  # PHP current version, generally installed as package/port
  prod:
    command: /usr/local/sbin/php-fpm

web_php_sites:
  admin.mail.nasqueron.org:
    domain: nasqueron.org
    subdomain: admin.mail
    user: web-org-nasqueron-mail-admin
    uid: 12001
    php-fpm: prod
    env:
      APPLICATION_ENV: production

  mail.nasqueron.org:
    domain: nasqueron.org
    subdomain: mail
    user: web-org-nasqueron-mail
    uid: 12000
    php-fpm: prod
