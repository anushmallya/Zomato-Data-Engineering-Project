{{
  config(
    materialized = 'incremental',
    unique_key = 'order_item_id',
    incremental_strategy = 'merge',
    on_schema_change = 'append_new_columns',
    alias = 'fact_order_items',
    )
}}

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
{% if is_incremental() %}
  WHERE o.order_timestamp > (SELECT COALESCE(MAX(order_timestamp), '1999-01-01') FROM {{ this }})
{% endif %}