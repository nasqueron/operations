#   -------------------------------------------------------------
#   Salt — Provision ViMbAdmin Config
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

vimbadmin_install_packages:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.pecl }}memcache
      - {{ packages_prefixes.php }}pear-Services_JSON
      - {{ packages_prefixes.php }}pdo_pgsql
      - {{ packages_prefixes.php }}gettext
      - {{ packages_prefixes.php }}xml
