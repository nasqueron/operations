#   -------------------------------------------------------------
#   Salt — Airflow
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Airflow DAGs composition
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for realm, dags_to_import in pillar.get("airflow_pipelines", {}).items() %}

/srv/airflow/{{ realm }}/src:
  file.directory

{% for name, args in dags_to_import.items() %}

{% set rev = args["source"].get("ref", "main") %}
{% set directory = args["source"].get("directory", "") %}

airflow_dags_{{ realm }}_{{ name }}_repo:
  git.latest:
    - name: {{ args["source"]["repository"] }}
    - target: /srv/airflow/{{ realm }}/src/{{ name }}
    - rev: {{ rev }}

airflow_dags_{{ realm }}_{{ name }}:
  file.copy:
    - name: /srv/airflow/{{ realm }}/dags
    - source: /srv/airflow/{{ realm }}/src/{{ name }}/{{ directory }}
    - force: True
    - user: 50000

{% endfor %}
{% endfor %}
