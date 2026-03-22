#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_tex:
  pkg.installed:
    - name: texlive-full

#   -------------------------------------------------------------
#   TeX Live - Fonts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/fonts/conf.avail/09-texlive.conf:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/tex/fonts.conf
    - template: jinja
    - context:
        dir: {{ dirs.share }}/texmf-dist/fonts
    - watch_in:
        cmd: devserver_software_tex_fonts

{{ dirs.etc }}/fonts/conf.d/09-texlive.conf:
  file.symlink:
    - target: ../conf.avail/09-texlive.conf

devserver_software_tex_fonts:
  cmd.run:
    - name: |
        fc-cache -fs
        touch {{ dirs.share }}/texmf-dist/fonts/.deployed
    - creates: {{ dirs.share }}/texmf-dist/fonts/.deployed
