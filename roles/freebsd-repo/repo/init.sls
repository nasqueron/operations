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

{% for ABI in pillar["nasqueron_packages_freebsd"]["ABI"] %}

"{{ repo.repo_dir }}/{{ ABI }}":
  file.directory:
    - user: builder

"{{ repo.repo_dir }}/{{ ABI }}/Makefile":
  file.managed:
    - source: salt://roles/freebsd-repo/repo/files/Makefile

{% endfor %}

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
