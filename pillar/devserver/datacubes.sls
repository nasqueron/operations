#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Datacubes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

datacubes:

  bak: &default {}
  git: *default
  t: *default

  xcombelle:
    user: xcombelle
    zfs_user: xcombelle
    zfs_auto_snapshot: True
