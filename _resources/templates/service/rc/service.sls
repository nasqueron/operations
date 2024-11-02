#   -------------------------------------------------------------
#   Salt — Provision %%service%%
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import services with context %}

#   -------------------------------------------------------------
#   %%service%% service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services.manager == "rc" %}

/etc/rc.conf.d/%%service%%:
  file.managed:
    - source: salt://%%cwd%%/files/rc/%%service%%.conf

%%service%%_running:
  service.running:
    - name: %%service%%

{% endif %}
