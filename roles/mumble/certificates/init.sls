#   -------------------------------------------------------------
#   Salt — Deploy SSL certificate for Mumble server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

mumble_certificates_update_script:
  file.managed:
    - name: /usr/local/bin/update-mumble-certificates
    - source: salt://roles/mumble/certificates/files/update-mumble-certificates.sh
