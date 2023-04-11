#!/bin/sh

#   -------------------------------------------------------------
#   rOPS — generate OCSP bundle with CA certificates
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Let's encrypt
#
#   Active certificates:
#     - Let’s Encrypt R3 - signed by ISRG Root X1
#     - Let’s Encrypt E1 - signed by ISRG Root X2
#
#   Disaster recovery certificates:
#     - Let’s Encrypt R4 - signed by ISRG Root X1
#     - Let’s Encrypt E2 - signed by ISRG Root X2
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

curl -sS https://letsencrypt.org/certs/lets-encrypt-r3.pem
curl -sS https://letsencrypt.org/certs/lets-encrypt-e1.pem

curl -sS https://letsencrypt.org/certs/lets-encrypt-r4.pem
curl -sS https://letsencrypt.org/certs/lets-encrypt-e2.pem

curl -sS https://letsencrypt.org/certs/isrg-root-x1-cross-signed.pem
curl -sS https://letsencrypt.org/certs/isrg-root-x2-cross-signed.pem
