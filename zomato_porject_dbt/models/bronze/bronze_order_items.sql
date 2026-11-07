{% set increamental_Val = 'source_ingest_time' %}
{{
  config(
    materialized = 'incremental',
    alias = 'order_items',
    unique_key = 'order_item_id',
    incremental_strategy='merge'
    )
}}

SELECT
    * EXCEPT(row_hash)
FROM {{ source('source', 'order_items') }}
{% if is_incremental() %}
WHERE {{increamental_Val}} > (SELECT COALESCE(MAX({{increamental_Val}}), '1900-01-01') FROM {{ this }})
{% endif %}