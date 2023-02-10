#   -------------------------------------------------------------
#   Salt — RabbitMQ
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .software

  # Content includes vhosts, exchanges, queues, users, privileges
  - .content
