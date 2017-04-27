#   -------------------------------------------------------------
#   Salt — Deploy Bonjour chaton
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Created:        2017-04-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

/opt/bonjour-chaton/certs:
  file.directory:
    - user: chaton
    - group: chaton-dev
    - dir_mode: 750

bonjour_chaton_certificates_private:
  cmd.run:
    - name: cp {{ dirs.etc }}/letsencrypt/live/robot.paysannerebelle.com/privkey.pem /opt/bonjour-chaton/certs/private.pem
    - creates: /opt/bonjour-chaton/certs/private.pem
  file.managed:
    - name: /opt/bonjour-chaton/certs/private.pem
    - user: chaton
    - group: chaton-dev
    - mode: 0600
    - replace: False
    - show_changes: False

bonjour_chaton_certificates_public:
  cmd.run:
    - name: cp {{ dirs.etc }}/letsencrypt/live/robot.paysannerebelle.com/fullchain.pem /opt/bonjour-chaton/certs/cert.pem
  file.managed:
    - name: /opt/bonjour-chaton/certs/cert.pem
    - user: chaton
    - group: chaton-dev
    - mode: 0644
