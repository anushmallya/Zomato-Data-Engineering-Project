{% set incremental_col_1, incremental_col_2 =  'source_ingest_time','menu_updated_datetime' %}

{{
  config(
    materialized = 'incremental',
    alias = 'menu',
    unique_key = ['menu_id','food_id'],
    incremental_strategy='merge'
    )
}}

SELECT
    menu_id,
    CAST(r_id AS INT) AS `restaurant_id`,
    f_id AS `food_id`,
    cuisine,
    CAST(REGEXP_REPLACE(TRIM(price), '[^0-9.]', '') AS DECIMAL(10,2)) AS price,
    source_ingest_time AS `menu_updated_datetime`
FROM {{ ref('bronze_menu') }}
WHERE r_id IS NOT NULL AND CAST(REGEXP_REPLACE(TRIM(price), '[^0-9.]', '') AS DECIMAL(10,2)) > 0
{% if is_incremental() %}
  AND {{incremental_col_1}} > (SELECT COALESCE(MAX({{incremental_col_2}}), '1900-01-01') FROM {{this}})
{% endif %}