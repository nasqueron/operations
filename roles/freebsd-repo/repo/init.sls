#   -------------------------------------------------------------
#   Salt — FreeBSD repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "roles/freebsd-repo/map.jinja" import repo with context %}

#   -------------------------------------------------------------
#   Create repository directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ repo.repo_dir }}:
  file.directory:
    - makedirs: True
    - user: builder

{{ repo.repo_dir }}/Makefile:
  file.managed:
    - source: salt://roles/freebsd-repo/repo/files/Makefile

#   -------------------------------------------------------------
#   Signature tool
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/bin/sign-freebsd-repo:
  file.managed:
    - source: salt://roles/freebsd-repo/repo/files/sign-freebsd-repo.sh.jinja
    - mode: 755
    - template: jinja
    - context:
        keydir: {{ repo.signing_key_dir }}
