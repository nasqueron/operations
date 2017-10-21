#   -------------------------------------------------------------
#   Salt — Salt master configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-04
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Wrapper binaries
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/salt-wrapper:
  file.managed:
    - mode: 755
    - source: salt://software/salt-wrapper/salt-wrapper.sh

{{ dirs.bin }}/salt-get-config-dir:
  file.managed:
    - mode: 755
    - source: salt://software/salt-wrapper/salt-get-config-dir.py

#   -------------------------------------------------------------
#   Wrapper configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/salt-wrapper.conf:
  file.managed:
    - source: salt://roles/saltmaster/salt-wrapper/files/salt-wrapper.conf

#   -------------------------------------------------------------
#   Wrapper manual
#
#   TODO: gzip those files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.man }}/man1/salt-get-config-dir.1:
  file.managed:
    - source: salt://software/salt-wrapper/man/salt-get-config-dir.1

{{ dirs.man }}/man1/salt-wrapper.1:
  file.managed:
    - source: salt://software/salt-wrapper/man/salt-wrapper.1

{{ dirs.man }}/man5/salt-wrapper.conf.5:
  file.managed:
    - source: salt://software/salt-wrapper/man/salt-wrapper.conf.5
