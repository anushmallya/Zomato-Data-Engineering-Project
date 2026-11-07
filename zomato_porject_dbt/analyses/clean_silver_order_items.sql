SELECT
    CAST(order_item_id AS INT),
    CAST(order_id AS INT),
    CAST(r_id AS INT) AS `restaurant_id`,
    f_id AS `food_id`
    CAST(price AS DECIMAL(10,2)),
    CAST(quantity AS INT),
    CAST(line_amount AS DECIMAL(10,2)),
    source_ingest_time AS `order_items_updated_datetime` 
FROM {{ ref('bronze_order_items') }}
WHERE order_item_id IS NOT NULL