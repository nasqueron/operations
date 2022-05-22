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
    ssh_key: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICiWLxPzS8X6NraVwsK95gFGe1pIuz+K0n7aw81nabcf jenkins-controller-equatower-cd
    network: cd

  ci:
    ssh_key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhhBMTjGguFBy2aOczmZ7NS14b57uoKnzepMtFHh7cpsmbp1Jvf7LOH0niyFOAMlVMqObXJ+8zsd+x9XqMlWUfVOF07D1/GUq09YA7DQsjMc6CdcW68VtcKcUdAnB3yUVX0fZ6bGwnTAnZvAq1oAxuLXE42eBQUti142ic0OF5y5ePs9gu9rOmUzLuydv2+iB34RuopF6VlzROlatyITvr4KPnAhEAuRiVBqWIIWvsT4EMYRlddXC21sPEqUHr3T7FgS2Kmp/1Iw4Hk98srC59lSYOmMLPlTSfuYIoRorGIv3UHeW5DHHeEN+wEnvTPAaO/fiWJfOQBHshWJFN4mOj jenkins@ci.nasqueron.org
    network: ci

  test:
    ssh_key: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxHVsr2GvbzlC1RDyXhJ71FeU8DeMUbjcdfcRgRluZ5 jenkins-controller-test
    network: jenkinsTest

#   -------------------------------------------------------------
#   Jenkins images
#
#   Each agent uses one Jenkins image.
#
#   An image can be used by several agents, so we've more nodes
#   available for parallel builds.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

jenkins_images:
  barebone: nasqueron/jenkins-agent-barebone
  node: nasqueron/jenkins-agent-node
  php: nasqueron/jenkins-agent-php
  rust: nasqueron/jenkins-agent-rust
