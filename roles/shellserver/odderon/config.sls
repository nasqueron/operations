#   -------------------------------------------------------------
#   Salt — Deploy Odderon unit (darkbot)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-19
#   Description:    Darkbot
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% nickserv_secret = salt["vault.read_secret"]("kv/service/odderon/nickserv")  %}

/opt/odderon/var/darkbot/setup.ini:
  file.managed:
    - name: salt://roles/shellserver/odderon/files/setup.ini
    - user: odderon
    - mode: 400
    - show_changes: False
    - template: jinja
    - context:
        sasl:
          user: {{ nickserv_secret["username"] }}
          pass: {{ nickserv_secret["password"] }}

/opt/odderon/var/darkbot/servers.ini:
  file.managed:
    - name: salt://roles/shellserver/odderon/files/servers.ini
    - user: odderon

#   -------------------------------------------------------------
#   File permissions and ownership
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

odderon_fix_permissions_and_ownership:
  file.managed:
    - name: /opt/odderon/var/darkbot/userlist.db
    - user: odderon
    - group: nasqueron-irc
    - chmod: 640
    - show_changes: False
    - replace: False
