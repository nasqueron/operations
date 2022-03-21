#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-06-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "roles/core/network/map.jinja" import interface_config with context %}
{% set network = salt['node.get']('network') %}

#   -------------------------------------------------------------
#   Interface
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for interface_name, interface in network["interfaces"].items() %}

{% if "skip_interface_configuration" not in interface.get("flags", []) %}
network_ipv4_{{ interface_name }}:
  file.managed:
    {% if interface_config["suffix"] == "interface" %}
    - name : {{ interface_config["config_path"] }}{{ interface_name }}
    {% else %}
    - name : {{ interface_config["config_path"] }}{{ interface["device"] }}
    {% endif %}
    - source: salt://roles/core/network/files/{{ interface_config["source_path"] }}
    - makedirs: True
    - template: jinja
    - defaults:
        interface: {{ interface }}
{% if grains['os_family'] == 'RedHat' %}
        prefix: {{ salt['network_utils.netmask_to_cidr_prefix'](interface['ipv4']['netmask']) }}
{% endif %}
{% endif %}

{% endfor %}

#   -------------------------------------------------------------
#   Routes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/routing/ipv4:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/routing_ipv4.rc
    - makedirs: True
    - template: jinja
    - context:
        ipv4_gateway: {{ network['ipv4_gateway'] }}
        ipv4_interface: {{ network['ipv4_interface'] }}
        ipv4_ovh_failover: {{ salt['node.has']('network:ipv4_ovh_failover') }}
{% endif %}
