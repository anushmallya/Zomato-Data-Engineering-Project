{% set incremental_col_1, incremental_col_2 =  'review_date','review_date' %}

{{
  config(
    materialized = 'incremental',
    alias = 'reviews',
    unique_key = 'review_id',
    incremental_strategy='merge'
    )
}}

SELECT
    CAST(r.review_id AS INT),
    CAST(r.order_id AS INT),
    CAST(r.user_id AS INT) AS `customer_id`,
    CAST(r.restaurant_id AS INT),
    CAST(r.rating AS DECIMAL(10, 2)),
    r.comment AS `reviews`,
    res.restaurant_city,
    r.review_date
FROM {{ ref('bronze_reviews') }} AS `r`
LEFT JOIN {{ ref('silver_restaurant') }} AS `res`
    ON res.restaurant_id = CAST(r.restaurant_id AS INT)
WHERE r.review_id IS NOT NULL
{% if is_incremental() %}
  AND {{incremental_col_1}} > (SELECT COALESCE(MAX({{incremental_col_2}}), '1900-01-01') FROM {{this}})
{% endif %}