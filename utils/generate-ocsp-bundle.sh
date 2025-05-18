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
#     - Let’s Encrypt R10 - signed by ISRG Root X1
#     - Let’s Encrypt R11 - signed by ISRG Root X1
#     - Let’s Encrypt E5  - signed by ISRG Root X1 and X2
#     - Let’s Encrypt E6  - signed by ISRG Root X1 and X2
#
#   Backup certificates:
#     - Let’s Encrypt R12 - signed by ISRG Root X1
#     - Let’s Encrypt R13 - signed by ISRG Root X1
#     - Let’s Encrypt R14 - signed by ISRG Root X1
#     - Let’s Encrypt E7  - signed by ISRG Root X1 and X2
#     - Let’s Encrypt E8  - signed by ISRG Root X1 and X2
#     - Let’s Encrypt E9  - signed by ISRG Root X1 and X2
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

curl -sS https://letsencrypt.org/certs/2024/r10.pem
curl -sS https://letsencrypt.org/certs/2024/r11.pem
curl -sS https://letsencrypt.org/certs/2024/r12.pem
curl -sS https://letsencrypt.org/certs/2024/r13.pem
curl -sS https://letsencrypt.org/certs/2024/r14.pem

curl -sS https://letsencrypt.org/certs/2024/e5.pem
curl -sS https://letsencrypt.org/certs/2024/e6.pem
curl -sS https://letsencrypt.org/certs/2024/e7.pem
curl -sS https://letsencrypt.org/certs/2024/e8.pem
curl -sS https://letsencrypt.org/certs/2024/e9.pem

curl -sS https://letsencrypt.org/certs/isrg-root-x1-cross-signed.pem
curl -sS https://letsencrypt.org/certs/isrg-root-x2-cross-signed.pem
