#   -------------------------------------------------------------
#   Salt — Provision software needed by other core roles
#                             to deploy on all servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages with context %}

#   -------------------------------------------------------------
#   Starship installation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
starship:
  pkg.installed
{% endif %}

{% if grains['kernel'] == 'Linux' and grains['osarch'] == 'x86_64' %}
install_starship:
  cmd.run:
    - name: snap install starship
    - creates: /var/lib/snapd/snap/bin/starship
{% endif %}

#   -------------------------------------------------------------
#   SELinux
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'RedHat' %}

/usr/local/share/selinux/systemd-hostnamed.te:
  file.managed:
    - source: salt://roles/core/userland-software/files/selinux/systemd-hostnamed.te
    - makedirs: True

/usr/local/share/selinux/systemd-hostnamed.pp:
  cmd.run:
    - name: make -f /usr/share/selinux/devel/Makefile systemd-hostnamed.pp
    - creates: /usr/local/share/selinux/systemd-hostnamed.pp
    - cwd: /usr/local/share/selinux

install_selinux_starship_module:
  cmd.run:
    - name: semodule -i systemd-hostnamed.pp
    - cwd: /usr/local/share/selinux
    - onchanges:
      - cmd: /usr/local/share/selinux/systemd-hostnamed.pp

{% endif %}
