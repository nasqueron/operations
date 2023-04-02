#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set containers = pillar.get('docker_containers', {}) %}

#   -------------------------------------------------------------
#   Base folder
#
#    :: general configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/nginx/nginx.conf:
  file.managed:
    - source: salt://roles/paas-docker/nginx/files/nginx.conf

nginx_dhparams:
  cmd.run:
    - name: openssl dhparam -out {{ dirs.etc }}/nginx/dhparams.pem 2048
    - creates: {{ dirs.etc }}/nginx/dhparams.pem

#   -------------------------------------------------------------
#   includes folder
#
#    :: general configuration
#    :: application-specific code
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/nginx/includes:
  file.recurse:
    - source: salt://roles/paas-docker/nginx/files/includes
    - dir_mode: 755
    - file_mode: 644

#   -------------------------------------------------------------
#   vhosts folder
#
#   :: fallback when a domain isn't found
#   :: server cover page
#   :: containers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/nginx/vhosts:
  file.directory:
    - dir_mode: 755

{{ dirs.etc }}/nginx/vhosts/000-fallback.conf:
  file.managed:
    - source: salt://roles/paas-docker/nginx/files/vhosts/base/fallback.conf

{{ dirs.etc }}/nginx/vhosts/001-server.conf:
  file.managed:
    - source: salt://roles/paas-docker/nginx/files/vhosts/base/server.conf
    - template: jinja
    - context:
         fqdn: {{ grains['fqdn'] }}
         ipv4: {{ grains['ipv4'] | join(" ") }}
         ipv6: "{{ salt['node.get_ipv6_list']() }}"

{% for service, instances in containers.items() %}
{% for instance, container in instances.items() %}
{% if 'host' in container %}

{% set vhost_config = salt["paas_docker.resolve_vhost_config_file"](service) %}

{{ dirs.etc }}/nginx/vhosts/{{ service }}/{{ instance }}.conf:
  file.managed:
    - source: salt://{{ vhost_config }}
    - mode: 644
    - makedirs: True
    - template: jinja
    - context:
        fqdn: {{ container['host'] }}
        app_port: {{ container['app_port'] }}
        aliases: {{ container['aliases'] | default('', true) | join(" ") }}
        # If the nginx configuration needs more key,
        # pass directly the container dictionary.
        args: {{ container }}

{% endif %}
{% endfor %}
{% endfor %}
