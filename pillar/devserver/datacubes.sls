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

#   -------------------------------------------------------------
#   Other directories needed by development work
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_directories:
  /var/dataroot:
    user: root
    group: ops
    mode: 775

  /var/dataroot/mediawiki.dereckson.be:
    user: web-be-dereckson-mw
    group: dereckson
    mode: 771

  # Staging area for Zed

  /var/dataroot/zed:
    user: dereckson
    mode: 711

  /var/dataroot/zed/cache:
    user: web-be-dereckson-zed51
    group: dereckson
    mode: 771

  /var/dataroot/zed/content:
    user: web-be-dereckson-zed51
    group: dereckson
    mode: 771
