#   -------------------------------------------------------------
#   Let's Encrypt Certificates
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

certificates:
  - hervil.nasqueron.org
  - mail.nasqueron.org
  - admin.mail.nasqueron.org

certificates_options:
  admin.mail.nasqueron.org:
    reload: sudo acmesh-nginxCheck
  hervil.nasqueron.org:
    reload: sudo acmesh-nginxCheck
  mail.nasqueron.org:
    shared_group: mail
