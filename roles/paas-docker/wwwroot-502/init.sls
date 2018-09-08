#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/var/wwwroot-502:
  file.recurse:
    - source: salt://wwwroot/502
    - exclude_pat: E@.git
    - include_empty: True
    - dir_mode: 755
    - file_mode: 644
