SELECT
    menu_id,
    CAST(r_id AS INT) AS `restaurant_id`,
    f_id AS `food_id`,
    cuisine,
    CAST(REGEXP_REPLACE(TRIM(price), '[^0-9.]', '') AS DECIMAL(10,2)) AS price
    source_ingest_time AS `meanu_updated_datetime`
FROM {{ ref('bronze_menu') }}
WHERE r_id IS NOT NULL AND CAST(REGEXP_REPLACE(TRIM(price), '[^0-9.]', '') AS DECIMAL(10,2)) > 0