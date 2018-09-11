#   -------------------------------------------------------------
#   Salt — Jenkins instances
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Jenkins realms
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

jenkins_realms:
  cd:
    ssh_key: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICiWLxPzS8X6NraVwsK95gFGe1pIuz+K0n7aw81nabcf jenkins-master-equatower-cd
    network: cd
