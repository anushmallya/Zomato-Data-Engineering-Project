{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge',
        alias='orders'
    )
}}

SELECT
    * EXCEPT(_rescued_data)
FROM read_files(
    '/Volumes/zomato_dep/source/source_data/orders.csv.gz',
    format => 'csv',
    header => true,
    multiLine => true,
    inferColumnTypes => false
)
{% if is_incremental() %}
WHERE order_timestamp > (SELECT COALESCE(MAX(order_timestamp), '1900-01-01') FROM {{ this }})
{% endif %}
