#   -------------------------------------------------------------
#   Salt — Prune tmux default configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   T2029
#   Don't provision root tmux config as default
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/etc/tmux.conf:
  file.absent

/usr/local/etc/tmux.conf:
  file.absent
