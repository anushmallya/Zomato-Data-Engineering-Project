{% set incremental_col_1, incremental_col_2 =  'order_timestamp','order_timestamp' %}

{{
  config(
    materialized = 'incremental',
    alias = 'orders',
    unique_key = 'order_id',
    incremental_strategy='merge'
    )
}}

SELECT
    CAST(o.order_id AS INT),
    CAST(o.order_timestamp AS TIMESTAMP),
    CAST(o.order_date AS DATE),
    CAST(o.user_id AS INT) AS `customer_id`,
    CAST(o.r_id AS INT)  AS `restaurant_id`,
    r.restaurant_city,
    o.cuisine,
    CAST(o.items_count AS INT) AS `order_item_count`,
    CAST(o.sales_qty AS INT) AS `order_sales_quantity`,
    CAST(o.subtotal AS INT) AS `order_subtotal`,
    CAST(o.discount AS INT) AS `order_discount`,
    CAST(o.delivery_fee AS INT) AS `order_delivery_fee`,
    CAST(o.gst AS INT) AS `order_gst`,
    CAST(o.sales_amount AS INT) AS `order_total_amount`,
    o.currency,
    o.payment_method,
    o.order_status,
    CASE
        WHEN LOWER(o.order_status) = 'delivered' THEN TRUE
        ELSE FALSE
    END AS `is_delivered`,
    CAST(o.customer_rating AS DECIMAL(3,1)),
    CAST(o.delivery_time_min AS DECIMAL(10,3)) 
FROM {{ ref('bronze_orders') }} AS `o`
LEFT JOIN {{ ref('silver_restaurant') }} AS `r`
    ON r.restaurant_id = CAST(o.r_id AS INT)
WHERE o.order_id IS NOT NULL
{% if is_incremental() %}
  AND {{incremental_col_1}} > (SELECT COALESCE(MAX({{incremental_col_2}}), '1900-01-01') FROM {{this}})
{% endif %}