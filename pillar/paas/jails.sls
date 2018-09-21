#   -------------------------------------------------------------
#   Salt — Jails
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

jails:
  ysul:
    ftp:
      lo: 127.0.2.1
      ipv4: 212.83.187.132
      ipv6: 2001:470:1f13:9e1:0:c0ff:ee:1

    mumble:
      lo: 127.0.2.2
      ipv4: 212.83.187.132
      ipv6: 2001:470:1f13:9e1:0:c0ff:ee:1

    # Test jail
    tonderon:
      lo: 127.0.2.3
      ipv4: 212.83.187.132
      ipv6: 2001:470:1f13:9e1:0:c0ff:ee:7
