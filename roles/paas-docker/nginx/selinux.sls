#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-23
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os_family'] == 'RedHat' %}

# On Fedora and downstreams, SELinux restricts the capability
# of HTTP server to connect to external servers.
#
# This feature allows nginx to connect to other servers,
# and so to act as a front-end server through proxy_pass.

httpd_can_network_connect:
  selinux.boolean:
    - value: True
    - persist: True

#   -------------------------------------------------------------
#   Custom SELinux policies
#
#   :: Give access to container files Let's Encrypt (T1364)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

policycoreutils-devel:
  pkg.installed

/usr/local/share/selinux/nginx.te:
  file.managed:
    - source: salt://roles/paas-docker/nginx/files/selinux/nginx.te
    - makedirs: True

/usr/local/share/selinux/nginx.pp:
  cmd.run:
    - name: make -f /usr/share/selinux/devel/Makefile nginx.pp
    - creates: /usr/local/share/selinux/nginx.pp
    - cwd: /usr/local/share/selinux

install_selinux_nginx_module:
  cmd.run:
    - name: semodule -i nginx.pp
    - cwd: /usr/local/share/selinux
    - onchanges:
      - cmd: /usr/local/share/selinux/nginx.pp

{% endif %}
