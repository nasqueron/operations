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
    - template: jinja
    - context:
        key: {{ repo.signing_key_dir }}/repo.key
