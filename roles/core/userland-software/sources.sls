#   -------------------------------------------------------------
#   Salt — Provision software needed by other core roles
#                             to deploy on all servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   FreeBSD
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/usr/local/etc/pkg/repos/Nasqueron.conf:
  file.managed:
    - source: salt://roles/core/userland-software/files/sources/Nasqueron.conf
    - makedirs: True

git:
  pkg.installed

ports_tree:
  cmd.run:
    - name: |
        mkdir -p /usr/ports
        cd /usr/ports && git init --initial-branch=main
        git remote add origin https://git.FreeBSD.org/ports.git
        git fetch --all
        git reset --hard origin/main
    - creates: /usr/ports/.git
{% endif %}

#   -------------------------------------------------------------
#   Redhat family
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'RedHat' and grains['os'] != 'Fedora' %}
epel-release:
  pkg.installed

/etc/yum.repos.d/nasqueron.repo:
  file.managed:
    - source: salt://roles/core/userland-software/files/sources/nasqueron.repo
{% endif %}

#   -------------------------------------------------------------
#   Debian
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'Debian' %}
/etc/apt/sources.list:
  file.managed:
    - source: salt://roles/core/userland-software/files/sources/sources.list
    - template: jinja
    - context:
        debian_version: {{ grains['oscodename'] }}

apt_update_debian_sources:
  cmd.run:
    - name: apt update
    - onchanges:
      - file: /etc/apt/sources.list
{% endif %}

#   -------------------------------------------------------------
#   Snapcraft
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['kernel'] == 'Linux' %}
snapd:
  pkg.installed
{% endif %}

{% if grains['os_family'] == 'RedHat' or grains['os'] == 'Arch' %}
snap_enable:
  cmd.run:
    - name: |
        systemctl enable --now snapd.socket
        systemctl restart snapd
        sleep 30
        touch /var/lib/snapd/.enabled
    - creates: /var/lib/snapd/.enabled

/snap:
  file.symlink:
    - target: /var/lib/snapd/snap
{% endif %}
