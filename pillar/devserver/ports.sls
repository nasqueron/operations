#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-01-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Ports to build manually
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ports:
  xaos:
    category: graphics
    name: xaos
    creates: /usr/local/bin/xaos
    options:
      set:
        - NLS
        - AALIB
      unset:
        - THREADS
        - GTK2
        - "X11"
