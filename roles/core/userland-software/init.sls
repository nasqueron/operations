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
#   -------------------------------------------------------------

{% if grains['os'] == 'CentOS' %}
epel-release:
  pkg.installed

/etc/yum.repos.d/nasqueron.repo:
  file.managed:
    - source: salt://roles/core/userland-software/files/nasqueron.repo
{% endif %}

{% if grains['kernel'] == 'Linux' %}
snapd:
  pkg.installed
{% endif %}

{% if grains['os_family'] == 'RedHat' or grains['os'] == 'Arch' %}
snap_enable:
  service.enabled:
    - name: snapd.socket

/snap:
  file.symlink:
    - target: /var/lib/snapd/snap
{% endif %}

#   -------------------------------------------------------------
#   Shells
#   -------------------------------------------------------------

shells:
  pkg.installed:
    - pkgs:
      - bash
      - zsh
      {% if grains['os'] == 'FreeBSD' %}
      - starship
      {% else %}
      - tcsh
      {% endif %}

{{ dirs.share }}/zsh/site-functions/_pm:
  file.managed:
    # At commit 683d331 - 2017-11-05
    - source: https://raw.githubusercontent.com/Angelmmiguel/pm/master/zsh/_pm
    - source_hash: deea33968be713cdbd8385d3a72df2dd09c444e42499531893133f009f0ce0ea

#   -------------------------------------------------------------
#   tmux
#   -------------------------------------------------------------

tmux:
  pkg.installed

/root/.tmux.conf:
  file.managed:
    - source: salt://roles/core/userland-software/files/tmux.conf

#   -------------------------------------------------------------
#   System administration utilities
#   -------------------------------------------------------------

sysadmin_utilities:
  pkg.installed:
    - pkgs:
      - tree
      - wget
      {% if grains['os'] != 'FreeBSD' %}
      - {{ packages.netcat }}
      {% endif %}
      {% if grains['os_family'] == 'RedHat' %}
      - psmisc
      {% endif %}
