#   -------------------------------------------------------------
#   Salt — Network — GRE tunnels
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "roles/core/network/map.jinja" import gre with context %}
{% set boot_loader = namespace(gre=false) %}
{% set is_router = salt["node.has_role"]("router") %}

#   -------------------------------------------------------------
#   Tunnels network configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for tunnel in salt['node.resolve_gre_tunnels']() %}

{% set boot_loader.gre = True %}

{{ gre.config_path }}{{ tunnel["description"] }}:
  file.managed:
    - source: salt://roles/core/network/files/{{ gre.source_path }}
    - makedirs: True
    - template: jinja
    - defaults: {{ tunnel }}
{% if grains['os_family'] == 'Debian' %}
    - context:
        interface: gre-{{ tunnel["network"] }}
{% endif %}


{% if not is_router and grains['os'] == 'FreeBSD' %}
# Only once iteration of the loop is expected, as it's not a router

/usr/local/etc/rc.d/route-drake:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/route-drake.service
    - mode: 755

/etc/rc.conf.d/route_drake:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/route_drake.rc
    - template: jinja
    - context:
        tunnel_endpoint: {{ tunnel["dst"] }}
{% endif %}

{% endfor %}

#   -------------------------------------------------------------
#   Kernel configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if boot_loader.gre %}

{% if grains['os'] == 'FreeBSD' %}
load_gre_kernel_module:
  file.append:
    - name: /boot/loader.conf
    - text: |

        if_gre_load="YES"
{% endif %}

{% if grains['os_family'] == 'Debian' %}
ip_gre:
  kmod.present:
    - persist: True
{% endif %}

{% endif %}
