{% set incremental_col_1, incremental_col_2 =  'source_ingest_time','food_updated_datetime' %}

{{
  config(
    materialized = 'incremental',
    alias = 'food',
    unique_key = 'food_id',
    incremental_strategy='merge'
    )
}}

SELECT 
    f_id AS `food_id`,
    CASE
        WHEN item IS NULL THEN 'Unknown'
        ELSE TRIM(item)
    END as `food_item`,
    CASE
        WHEN veg_or_non_veg IS NULL THEN 'Unknown'
        ELSE TRIM(veg_or_non_veg)
    END as `food_catagory`,
    source_ingest_time AS `food_updated_datetime`
FROM {{ ref('bronze_food') }}
WHERE f_id IS NOT NULL
{% if is_incremental() %}
  AND {{incremental_col_1}} > (SELECT COALESCE(MAX({{incremental_col_2}}), '1900-01-01') FROM {{this}})
{% endif %}