#   -------------------------------------------------------------
#   Salt — Hotfixes to mitigate bugs and security issues
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   MariaDB 10.11
#
#   Port for MariaDB 10.11 has been added in April 2023 and
#   isn't currently available in quarterly.
#
#   The new cluster db-B needs it for proper Unicode collation.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has_role']('dbserver-mysql') %}

/etc/pkg/FreeBSD.conf:
  file.replace:
    - pattern: quarterly
    - repl: latest

{% endif %}
