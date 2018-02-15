#   -------------------------------------------------------------
#   Salt — Provision static *.nasqueron.org websites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% for domain in pillar['web_static_sites'] %}
{% for subdomain in pillar['web_static_sites'][domain] %}
/var/wwwroot/{{ domain }}/{{ subdomain }}:
  file.recurse:
    - source: salt://wwwroot/{{ domain }}/{{ subdomain }}
    - exclude_pat: E@.git
    - include_empty: True
    - dir_mode: 755
    - file_mode: 644
    - user: {{ domain }}
    - group: web
{% endfor %}
{% endfor %}
