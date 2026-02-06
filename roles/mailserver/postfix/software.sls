#   -------------------------------------------------------------
#   Mail - Postfix
#   -------------------------------------------------------------
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

postfix_install:
  pkg.installed:
    - pkgs:
      - maildrop
      - mailman
      - postfix-pgsql
      - postfix-policyd-spf-perl
