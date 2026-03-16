{% macro log_run_results() %}
 
  {% set failed_models = [] %}
 
  {% for result in results %}
    {% if result.status in ('error', 'fail') %}
      {% do failed_models.append(result.node.name) %}
    {% endif %}
  {% endfor %}
 
  {% if failed_models | length > 0 %}
    {% set query %}
      CALL util.send_failure_email(
        '{{ failed_models | join(", ") }}',
        '{{ run_started_at }}'
      );
    {% endset %}
    {% do run_query(query) %}
  {% endif %}
 
{% endmacro %}