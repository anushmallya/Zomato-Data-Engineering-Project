SELECT
    CAST(id AS INT) AS `restaurant_id`,
    CASE
        WHEN TRIM(LOWER(name)) = 'kfc' THEN 'KFC'
        WHEN name IS NULL THEN 'unknown'
        ELSE TRIM(INITCAP(LOWER(name)))
    END as `restaurant_name`,
    CASE
        WHEN city IS NULL THEN 'unknown'
        WHEN LOCATE(',', city) > 0 THEN TRIM(REGEXP_EXTRACT(city, '[^,]+$', 0))
        WHEN LOCATE('_', city) > 0 THEN TRIM(SUBSTRING(city,1,(LOCATE('_',city)-1)))
        WHEN LOCATE('-', city) > 0 THEN TRIM(SUBSTRING(city,1,(LOCATE('-',city)-1)))
        ELSE TRIM(city) 
    END as `restaurant_city`,
    CAST(NULLIF(rating,'--') AS DECIMAL(3,1)) AS `restaurant_ratings`,
    CASE
        WHEN rating_count IS NULL THEN 'Unknown'
        ELSE TRIM(INITCAP(rating_count))
    END AS `restaurant_rating_count`,
    CAST(REPLACE(cost,'₹ ','') AS INT) AS `Min_Amount_for_Two`,
    cuisine,
    CASE
        WHEN lic_no = 'license' OR lic_no IS NULL THEN 'Not Provided'
        ELSE lic_no
    END as `retaurant_liense_no`,
    source_ingest_time AS `restaurant_updated_datetime`
FROM {{ ref('bronze_restaurant') }}
WHERE id IS NOT NULL