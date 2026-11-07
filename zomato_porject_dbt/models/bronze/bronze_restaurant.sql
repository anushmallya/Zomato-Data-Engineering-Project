{% set increamental_Val = 'source_ingest_time' %}
{{
  config(
    materialized = 'incremental',
    alias = 'restaurant',
    unique_key = 'id',
    incremental_strategy='merge'
    )
}}

SELECT
    * EXCEPT(row_hash)
FROM {{ source('source', 'restaurant') }}
{% if is_incremental() %}
WHERE {{increamental_Val}} > (SELECT COALESCE(MAX({{increamental_Val}}), '1900-01-01') FROM {{ this }})
{% endif %}