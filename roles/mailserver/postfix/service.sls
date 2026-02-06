#   -------------------------------------------------------------
#   Mail - Postfix
#   -------------------------------------------------------------
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

postfix_running:
  service.running:
    - name: postfix
    - enable: True
