#   -------------------------------------------------------------
#   Salt :: Alkane :: Nasqueron PaaS for static and PHP sites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages, services with context %}
{% set network = salt['node.resolve_network']() %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alkane_software:
  pkg.installed:
    - name: alkane

{{ dirs.etc }}/alkane.conf:
  file.managed:
    - source: salt://roles/webserver-alkane/alkane/files/alkane.conf

#   -------------------------------------------------------------
#   Recipes
#
#   The _lib/ directoy offers ready-to-use solution for init or update
#   You can use them with:
#
#   alkane_recipes:
#     foo.domain.tld:
#       init: git-clone.sh
#       update: git-pull.sh
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

recipes_dependencies:
  pkg.installed:
    - pkgs:
      - {{ packages.composer }}
      - jq
      - yarn

/usr/local/libexec/alkane:
  file.recurse:
    - source: salt://roles/webserver-alkane/alkane/files/recipes
    - dir_mode: 755
    - file_mode: 555

{% for site_name, recipes in pillar.get("alkane_recipes", {}).items() %}
/usr/local/libexec/alkane/{{ site_name }}:
  file.directory

{% for action, recipe in recipes.items() %}
/usr/local/libexec/alkane/{{ site_name }}/{{ action }}:
  file.symlink:
    - target: /usr/local/libexec/alkane/_lib/{{ recipe }}
{% endfor %}

{% endfor %}

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services.manager == "rc" %}

/etc/rc.conf.d/alkane:
  file.managed:
    - source: salt://roles/webserver-alkane/alkane/files/alkane.rc
    - template: jinja
    - context:
        address: {{ network["private_ipv4_address"] | default("localhost") }}

alkane_service:
  service.running:
    - name: alkane

{% endif %}
