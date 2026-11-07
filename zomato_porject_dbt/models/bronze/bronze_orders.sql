{% set increamental_Val = 'order_timestamp' %}
{{
  config(
    materialized = 'incremental',
    alias = 'orders',
    unique_key = 'order_id',
    incremental_strategy='merge'
    )
}}

SELECT
    *
FROM {{ source('source', 'orders') }}
{% if is_incremental() %}
WHERE {{increamental_Val}} > (SELECT COALESCE(MAX({{increamental_Val}}), '1900-01-01') FROM {{ this }})
{% endif %}