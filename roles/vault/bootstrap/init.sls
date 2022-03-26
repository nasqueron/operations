#   -------------------------------------------------------------
#   Salt — Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------
#                                                 ,  ,
#                                                / \/ \
#                                               (/ //_ \_
#      .-._                                      \||  .  \
#       \  '-._                            _,:__.-"/---\_ \
#  ______/___  '.    .--------------------'~-'--.)__( , )\ \
# `'--.___  _\  /    |   HERE BE DRAGONS.      ,'    \)|\ `\|
#      /_.-' _\ \ _:,_                               " ||   (
#    .'__ _.' \'-/,`-~`  This unit is only intended    |/
#        '. ___.> /=,|   for disaster recovery plan B. |
#         / .-'/_ )  |   Plan A is to restore storage. |
#    snd  )'  ( /(/  '---------------------------------'
#              \\ "
#               '=='

vault_bootstrap_dependencies:
  pkg.installed:
    - jq

/usr/local/bin/vault-initialize:
  file.managed:
    - source: salt://roles/vault/bootstrap/files/vault-initialize.sh
    - mode: 755

# As Salt doesn't have a token for the Vault installation,
# we can't run this script. Run it with a root token or
# a token with the "vault_bootstrap" policy.
