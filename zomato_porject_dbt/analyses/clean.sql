SELECT DISTINCT
    CAST(REGEXP_REPLACE(TRIM(price), '[^0-9.]', '') AS DECIMAL(10,2))
FROM {{ ref('bronze_menu') }}
WHERE price = '40'