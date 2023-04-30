#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-21
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Provision /opt/phabricator from Git repositories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

libphutil_repository:
  git.latest:
    - name: https://secure.phabricator.com/source/libphutil.git
    - target: /opt/phabricator/libphutil

arcanist_repository:
  git.latest:
    - name: https://secure.phabricator.com/diffusion/ARC/arcanist.git
    - target: /opt/phabricator/arcanist
    - update_head: False

phabricator_repository:
  git.latest:
    - name: https://secure.phabricator.com/source/phabricator.git
    - target: /opt/phabricator/phabricator
    - update_head: False

#   -------------------------------------------------------------
#   Extra phutil libraries
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

shellcheck_linter_repository:
  git.latest:
    - name: https://devcentral.nasqueron.org/source/shellcheck-linter.git
    - target: /opt/phabricator/shellcheck-linter

clang_linter_repository:
  git.latest:
    - name: https://github.com/vhbit/clang-format-linter
    - target: /opt/phabricator/clang-format-linter

#   -------------------------------------------------------------
#   Aliases
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/arc:
  file.symlink:
    - target: /opt/phabricator/arcanist/bin/arc

devserver_aliases_clang-format:
  cmd.script:
    - source: salt://roles/devserver/userland-software/files/install-clang-format-alias.py
    - args: {{ dirs.bin }}
    - creates: {{ dirs.bin }}/clang-format
