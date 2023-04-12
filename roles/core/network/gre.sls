#   -------------------------------------------------------------
#   Salt — Network — GRE tunnels
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "roles/core/network/map.jinja" import gre with context %}
{% set boot_loader = namespace(gre=false) %}

#   -------------------------------------------------------------
#   Tunnels network configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for tunnel in salt['node.resolve_gre_tunnels']() %}

{% set boot_loader.gre = True %}

{{ gre.config_path }}{{ tunnel["network"] }}:
  file.managed:
    - source: salt://roles/core/network/files/{{ gre.source_path }}
    - makedirs: True
    - template: jinja
    - defaults: {{ tunnel }}
{% if grains['os_family'] == 'Debian' %}
    - context:
        interface: gre-{{ tunnel["network"] }}
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
