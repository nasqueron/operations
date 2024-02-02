#   -------------------------------------------------------------
#   Salt — NextCloud
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages_prefixes with context %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nextcloud_software:
  pkg.installed:
    - pkgs:
      # Dependencies
      - {{ packages_prefixes.php }}sysvsem
      - {{ packages_prefixes.pecl }}APCu
      - {{ packages_prefixes.php }}opcache
      - {{ packages_prefixes.php }}ldap
      - {{ packages_prefixes.php }}gmp
      - {{ packages_prefixes.php }}exif
      - {{ packages_prefixes.php }}bz2
      - openldap26-client

      # NextCloud
      - nextcloud-{{ packages_prefixes.php | replace("-", "") }}
