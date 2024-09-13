#   -------------------------------------------------------------
#   Salt — Provision software needed by other core roles
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages with context %}

#   -------------------------------------------------------------
#   Software sources
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/usr/local/etc/pkg/repos/Nasqueron.conf:
  file.managed:
    - source: salt://roles/core/userland-software/files/Nasqueron.conf
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

{% if grains['os_family'] == 'RedHat' and grains['os'] != 'Fedora' %}
epel-release:
  pkg.installed

/etc/yum.repos.d/nasqueron.repo:
  file.managed:
    - source: salt://roles/core/userland-software/files/nasqueron.repo
{% endif %}

{% if grains['os'] == 'Debian' %}
/etc/apt/sources.list:
  file.managed:
    - source: salt://roles/core/userland-software/files/sources.list
    - template: jinja
    - context:
        debian_version: {{ grains['oscodename'] }}

apt_update_debian_sources:
  cmd.run:
    - name: apt update
    - onchanges:
      - file: /etc/apt/sources.list
{% endif %}

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

#   -------------------------------------------------------------
#   Shells
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

shells:
  pkg.installed:
    - pkgs:
      - bash
      - zsh
      {% if grains['kernel'] == 'Linux' %}
      - tcsh
      {% endif %}

      # Shell utilities
      {% if grains['os'] == 'FreeBSD' %}
      - starship
      {% endif %}

{% if grains['kernel'] == 'Linux' and grains['osarch'] == 'x86_64' %}
install_starship:
  cmd.run:
    - name: snap install starship
    - creates: /var/lib/snapd/snap/bin/starship
{% endif %}

/usr/local/share/zsh/site-functions/_pm:
  file.managed:
    # At commit 683d331 - 2017-11-05
    - source: https://raw.githubusercontent.com/Angelmmiguel/pm/master/zsh/_pm
    - source_hash: deea33968be713cdbd8385d3a72df2dd09c444e42499531893133f009f0ce0ea
    - makedirs: True

#   -------------------------------------------------------------
#   tmux
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

tmux:
  pkg.installed

{{ dirs.etc }}/tmux.conf:
  file.managed:
    - source: salt://roles/core/userland-software/files/tmux.conf

{{ dirs.bin }}/tmux-reattach:
  file.managed:
    - source: salt://roles/core/userland-software/files/tmux-reattach.sh
    - mode: 755

#   -------------------------------------------------------------
#   Python
#
#   The "python3" package takes care on FreeBSD to create
#   the symbolic link to the relevant Python 3.x version.
#
#   If Python is implicitly installed instead, it will be
#   a package like python3.9 without the symlink.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

python3:
  pkg.installed

#   -------------------------------------------------------------
#   System administration utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

sysadmin_utilities:
  pkg.installed:
    - pkgs:
      - bat
      - colordiff
      - nano
      - ripgrep
      - tree
      - wget
      {% if grains['os'] == 'FreeBSD' %}
      - gnu-watch
      {% else %}
      - {{ packages.netcat }}
      - net-tools
      {% endif %}
      {% if grains['os_family'] == 'RedHat' %}
      - patch
      - psmisc
      - tar
      {% endif %}

{% if grains['os'] == 'Debian' %}
/usr/bin/bat:
  file.symlink:
    - target: /usr/bin/batcat
{% endif %}

{% if grains['os'] == 'FreeBSD' %}
/usr/local/bin/gwatch:
  file.symlink:
    - target: /usr/local/bin/gnu-watch
{% endif %}

{% if grains['os_family'] == 'RedHat' %}
{{ dirs.bin }}/new-partition:
  file.managed:
    - source: salt://roles/core/userland-software/files/new-partition.sh
    - mode: 755
{% endif %}

#   -------------------------------------------------------------
#   Nano configuration
#
#   YAML syntax highlighting is only available on newest versions:
#   As checked 2023-04-19, it's not available on Debian and Rocky.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['file.file_exists'](dirs["share"] + "/nano/yaml.nanorc") %}
nano_sls_support:
  file.replace:
    - name: {{ dirs.share }}/nano/yaml.nanorc
    - pattern: {{ 'syntax yaml "\.ya?ml$"' | regex_escape }}
    - repl: syntax yaml "\.(ya?ml|sls)$"
{% endif %}

{{ dirs.etc }}/nanorc:
  nano.config_autogenerated:
    - nanorc_dir: {{ dirs.share }}/nano
