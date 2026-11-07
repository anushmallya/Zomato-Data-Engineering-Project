{% set increamental_Val = 'source_ingest_time' %}
{{
  config(
    materialized = 'incremental',
    alias = 'menu',
    unique_key = ['menu_id','f_id'],
    incremental_strategy='merge'
    )
}}

SELECT
    * EXCEPT(row_hash)
FROM {{ source('source', 'menu') }}
{% if is_incremental() %}
WHERE {{increamental_Val}} > (SELECT COALESCE(MAX({{increamental_Val}}), '1900-01-01') FROM {{ this }})
{% endif %}