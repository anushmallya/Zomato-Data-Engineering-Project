{% set increamental_Val = 'source_ingest_time' %}
{{
  config(
    materialized = 'incremental',
    alias = 'users',
    unique_key = 'user_id',
    incremental_strategy='merge'
    )
}}

SELECT
    * EXCEPT(row_hash)
FROM {{ source('source', 'users') }}
{% if is_incremental() %}
WHERE {{increamental_Val}} > (SELECT COALESCE(MAX({{increamental_Val}}), '1900-01-01') FROM {{ this }})
{% endif %}