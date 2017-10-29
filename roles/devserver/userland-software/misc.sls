#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages, packages_prefixes with context %}

devserver_software_misc_vcs:
  pkg:
    - installed
    - pkgs:
      # VCS
      - cvs
      - fossil
      - subversion
      # Bridges
      - cvs2svn
      - {{ packages_prefixes.python2 }}hg-git

devserver_software_misc_media:
  pkg:
    - installed
    - pkgs:
      - ffmpeg2theora
      - opencore-amr
      - opus
      - speex
      - speexdsp
      - x265

devserver_software_misc_text_processing:
  pkg:
    - installed
    - pkgs:
      - antiword
      - odt2txt
      - texlive-full

devserver_software_misc_security:
  pkg:
    - installed
    - pkgs:
      - aescrypt
      - pwgen
      - vault

devserver_software_misc_tools:
  pkg:
    - installed
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
  pkg:
    - installed
    - pkgs:
      - ccache
      - portmaster
      - portshaker
      - porttools
      - poudriere
{% endif %}

devserver_software_misc_gadgets:
  pkg:
    - installed
    - pkgs:
      - asciiquarium
      - binclock
      - ditaa
      - epte
      - weatherspect

devserver_software_misc_games:
  pkg:
    - installed
    - pkgs:
      - bsdgames
      - textmaze
