#   -------------------------------------------------------------
#   Salt — Provision robot.paysannerebelle.com website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Collectif des paysannes et paysans rebelles
#   Created:        2017-04-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has_web_content'](".com/paysannerebelle") %}

{% set wwwgroup = "www-data" %}

#   -------------------------------------------------------------
#   Site directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/paysannerebelle.com/robot:
  file.directory:
    - user: hlp
    - group: {{ wwwgroup }}
    - dir_mode: 711
    - makedirs: True

{% endif %}
