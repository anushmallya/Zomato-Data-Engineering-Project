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