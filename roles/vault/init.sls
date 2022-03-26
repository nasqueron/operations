#   -------------------------------------------------------------
#   Salt — Vault
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .vault

  # Depends of Vault installed
  - .policies

#   -------------------------------------------------------------
#   Disaster recovery process
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#   The bootstrap unit can be run once for the whole cluster
#   if you wish to regerate the Vault configuration from scratch
#   instead of restoring the storage back-end.
#
#   As such, .bootstrap should NOT be included in the includes list.
