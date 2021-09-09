#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set subdomains = salt['node.filter_by_role']('web_content_jenkins_cd') %}

{% for subdomain in subdomains %}
/var/run/deploy/{{ subdomain }}.nasqueron.org:
  file.symlink:
    - target: /var/wwwroot/nasqueron.org/{{ subdomain }}
    - user: deploy
    - group: deploy
{% endfor %}
