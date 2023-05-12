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

  dereckson_bak: &dck
    user: dereckson
    zfs_user: dereckson
    zfs_auto_snapshot: True

  xcombelle:
    user: xcombelle
    zfs_user: xcombelle
    zfs_auto_snapshot: True
