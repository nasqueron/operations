#   -------------------------------------------------------------
#   Salt — Provision IRC software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-04-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   IRC clients
#   -------------------------------------------------------------

irc_clients:
  pkg:
    - installed
    - pkgs:
      - irssi
      - irssi-scripts
      - weechat
      {% if grains['os'] != 'Debian' and grains['os'] != 'Ubuntu' %}
      # Reference: supremetechs.com/tag/bitchx-removed-from-debian
      - bitchx
      {% endif %}

#   -------------------------------------------------------------
#   Bouncers
#   -------------------------------------------------------------

irc_bouncers:
  pkg:
    - installed
    - pkgs:
      - znc

#   -------------------------------------------------------------
#   Bots
#
#   Don't bother installing eggdrop, everyone loves to compile it.
#   -------------------------------------------------------------

#   So we don't really have anything to install here.

#   -------------------------------------------------------------
#   Misc
#   -------------------------------------------------------------

irc_misc:
  pkg:
    - installed
    - pkgs:
      - bitlbee
      - pisg
