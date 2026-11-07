{{
  config(
    materialized = 'incremental',
    unique_key = 'order_id',
    incremental_strategy = 'merge',
    on_schema_change = 'append_new_columns',
    )
}}

SELECT
    * EXCEPT(
        `currency`)
FROM {{ ref('silver_orders') }}
{% if is_incremental() %}
  WHERE order_timestamp > (SELECT COALESCE(MAX(order_timestamp), '1999-01-01') FROM {{ this }})
{% endif %}