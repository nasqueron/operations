#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers :: services
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    List of the roles configured through services API.
#                   They are typically run on the Salt primary server,
#                   especially as they can need Vault credentials,
#                   but they don't touch any file *directly*.
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

base:
  'local':
    - roles/saas-rabbitmq
