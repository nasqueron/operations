#   -------------------------------------------------------------
#   Salt — Bastion - Yubikeys
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-02-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os_family'] == 'RedHat' %}

# On Fedora and downstreams, SELinux restricts the capability
# of SSHD to connect to external servers.
#
# From Fedora 18, a flag to allow connection for Yubikeys
# authentication has been provided.
#
# Reference: https://bugzilla.redhat.com/show_bug.cgi?id=841693

selinux_authlogin_yubikey:
  cmd.run:
    - name: setsebool -P authlogin_yubikey 1

{% endif %}
