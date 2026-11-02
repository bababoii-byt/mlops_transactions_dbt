{% macro amount_bucket(column_name) %}
    multiIf(
        {{ column_name }} < 100, 'SMALL',
        {{ column_name }} < 1000, 'MEDIUM',
        'LARGE'
    )
{% endmacro %}
