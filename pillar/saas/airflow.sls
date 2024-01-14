#   -------------------------------------------------------------
#   Salt — Airflow
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Airflow DAGs composition
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

airflow_pipelines:

  # Realm: nasqueron

  nasqueron:

    datasources:
      source:
        # DAGs currently living in test branch - D2754
        repository: https://devcentral.nasqueron.org/source/datasources.git
        ref: pipelines
        directory: _pipelines/dags
    
      python_dependencies:
        - requests

