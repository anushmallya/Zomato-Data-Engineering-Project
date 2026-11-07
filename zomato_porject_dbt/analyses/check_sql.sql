Select
    oi.order_item_id,
    oi.order_id,
    oi.restaurant_id,
    oi.food_id,
    o.order_timestamp,
    o.order_date,
    o.restaurant_city,
    oi.price,
    oi.quantity,
    oi.line_amount
FROM {{ ref('silver_order_items') }} as `oi`
LEFT JOIN {{ ref('silver_orders') }} as `o`
    ON oi.order_id = o.order_id