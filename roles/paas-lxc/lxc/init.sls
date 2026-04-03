#   -------------------------------------------------------------
#   Salt — LXC
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

lxc_packages:
  pkg.installed:
    - pkgs:
      - lxc
      {% if grains['os_family'] == 'RedHat' %}
      - lxc-extra
      - lxc-templates
      {% endif %}
