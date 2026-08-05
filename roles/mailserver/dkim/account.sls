#   -------------------------------------------------------------
#   Salt — OpenDKIM configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set uids = pillar["uids"] %}
{% set gids = pillar["gids"] %}

#   -------------------------------------------------------------
#   OpenDKIM user account
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

opendkim:
  group.present:
    - gid: {{ gids["opendkim"] }}
  user.present:
    - uid: {{ uids["opendkim"] }}
    - gid: {{ gids["opendkim"] }}
    - home: /var/run/milteropendkim
