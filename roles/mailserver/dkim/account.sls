#   -------------------------------------------------------------
#   Salt — OpenDKIM configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   OpenDKIM user account
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

opendkim:
  group.present:
    - gid: 836
  user.present:
    - uid: 836
    - gid: 836
    - home: /var/run/milteropendkim
