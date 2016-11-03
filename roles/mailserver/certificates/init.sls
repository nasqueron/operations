#   -------------------------------------------------------------
#   Salt — Deploy SSL certificate for SMTP server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-11-03
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

smtp_certificates_update_script:
  file.managed:
    - name: /usr/local/bin/update-smtp-certificates
    - source: salt://roles/mailserver/certificates/files/update-smtp-certificates
