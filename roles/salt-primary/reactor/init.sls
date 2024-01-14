#   -------------------------------------------------------------
#   Salt — Provision a salt primary server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Salt configuration
#
#   When reactor is available, symlink it.
#
#   As Salt primary server will fail if a configuration file
#   is not readable, it is necessary to remove the symlink when
#   the reactor config does not exist.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt["slsutil.file_exists"]("reactor/reactor.conf") %}

{{ dirs.etc }}/salt/master.d/reactor.conf:
  file.symlink:
    - target: /opt/salt/nasqueron-operations/reactor/reactor.conf

{% else %}

{{ dirs.etc }}/salt/master.d/reactor.conf:
  file.absent

{% endif %}
