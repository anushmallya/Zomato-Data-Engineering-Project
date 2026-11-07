SELECT
    CAST(r.review_id AS INT),
    CAST(r.order_id AS INT),
    CAST(r.user_id AS INT) AS `customer_id`,
    CAST(r.restaurant_id AS INT),
    CAST(r.rating AS INT),
    r.comment AS `reviews`,
    res.restaurant_city,
    r.review_date
FROM {{ ref('bronze_reviews') }} AS `r`
LEFT JOIN {{ ref('silver_restaurant') }} AS `res`
    ON res.restaurant_id = CAST(r.restaurant_id AS INT)
WHERE r.review_id IS NOT NULL