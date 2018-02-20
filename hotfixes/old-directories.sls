#   -------------------------------------------------------------
#   Salt — Hotfixes to mitigate bugs and security issues
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-23
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   T1325
#   We now provision /var/wwwroot/<domain></<subdomain> for
#   all servers and not only for the web servers.
#
#   As such, /var/www/html nginx default directory on shellserver
#   role can be pruned.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has_role']('shellserver') %}

/var/www/html:
  file.absent

{% endif %}
