{% set increamental_Val = 'review_date' %}
{{
  config(
    materialized = 'incremental',
    alias = 'reviews',
    unique_key = 'review_id',
    incremental_strategy='merge'
    )
}}

SELECT
    *
FROM {{ source('source', 'reviews') }}
{% if is_incremental() %}
WHERE {{increamental_Val}} > (SELECT COALESCE(MAX({{increamental_Val}}), '1900-01-01') FROM {{ this }})
{% endif %}