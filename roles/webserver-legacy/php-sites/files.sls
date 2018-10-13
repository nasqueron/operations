#   -------------------------------------------------------------
#   Salt — Provision PHP websites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Sites content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for site in pillar['web_php_sites'].values() %}

{% if 'target' in site %}

{{ site['target'] }}:
  file.recurse:
    - source: salt://{{ site['source'] }}
    - exclude_pat: E@.git
    - include_empty: True
    - dir_mode: 711
    - file_mode: keep
    - user: {{ site['user'] }}
    - group: web

{% endif %}

{% endfor %}
