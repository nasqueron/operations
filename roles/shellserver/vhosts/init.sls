#   -------------------------------------------------------------
#   Salt — vhosts configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2017-01-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Configuration file
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/etc/vhosts:
  file.managed:
    - source: salt://roles/shellserver/vhosts/files/vhosts.{{ grains['id'] }}
    - mode: 644

#   -------------------------------------------------------------
#   Command file
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/bin/vhosts:
  file.managed:
    - source: salt://roles/shellserver/vhosts/files/vhosts
    - mode: 755
