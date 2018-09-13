#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages, packages_prefixes with context %}

devserver_software_misc_vcs:
  pkg.installed:
    - pkgs:
      # VCS
      - cvs
      - fossil
      - subversion
      # Bridges
      - cvs2svn
      - {{ packages_prefixes.python2 }}hg-git

devserver_software_misc_media:
  pkg.installed:
    - pkgs:
      - ffmpeg2theora
      - opencore-amr
      - opus
      - speex
      - speexdsp
      - x265

devserver_software_misc_text_processing:
  pkg.installed:
    - pkgs:
      - antiword
      - odt2txt
      - texlive-full

devserver_software_misc_security:
  pkg.installed:
    - pkgs:
      - aescrypt
      - pwgen
      - vault

devserver_software_misc_tools:
  pkg.installed:
    - pkgs:
      - boxes
      - cursive
      - fusefs-s3fs
      - gist
      - p7zip
      - primegen
      - rsync
      - unix2dos
      {% if grains['os'] == 'FreeBSD' %}
      - gawk
      {% endif %}

{% if grains['os'] == 'FreeBSD' %}
devserver_software_misc_ports:
  pkg.installed:
    - pkgs:
      - ccache
      - portmaster
      - portshaker
      - porttools
      - poudriere
      - portsearch

portsearch_database:
  cmd.run:
    - name: portsearch -u
    - creates: /var/db/portsearch
    - require:
      - pkg: devserver_software_misc_ports

/var/cache/ccache:
  file.directory

/etc/make.conf:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/make.conf

freebsd_kernel_modules:
  pkg.installed:
    - pkgs:
      - pefs-kmod

freebsd_kernel_modules_enable:
  module.wait:
    - name: kmod.load
    - mod: pefs
    - persist: True
    - watch:
        - pkg: freebsd_kernel_modules
{% endif %}

devserver_software_misc_p2p:
  pkg.installed:
    - pkgs:
      - transmission-daemon
      - transmission-web

devserver_software_misc_gadgets:
  pkg.installed:
    - pkgs:
      - asciiquarium
      - binclock
      - ditaa
      - epte
      - weatherspect

devserver_software_misc_games:
  pkg.installed:
    - pkgs:
      - bsdgames
      - textmaze

devserver_software_misc_network:
  pkg.installed:
    - pkgs:
      - getdns
      - iftop
      {% if grains['os_family'] == 'Debian' %}
      - sockstat
      {% endif %}

#   -------------------------------------------------------------
#   Custom simple binaries
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/shell:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/shell.py
    - mode: 755
