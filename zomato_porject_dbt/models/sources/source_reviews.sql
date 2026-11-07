{{
    config(
        materialized='incremental',
        unique_key='review_id',
        incremental_strategy='merge',
        alias='reviews'
    )
}}


SELECT
    * EXCEPT(_rescued_data)
FROM read_files(
    '/Volumes/zomato_dep/source/source_data/reviews.csv.gz',
    format => 'csv',
    header => true,
    multiLine => true,
    inferColumnTypes => false
)
{% if is_incremental() %}
WHERE review_date > (SELECT COALESCE(MAX(review_date), '1900-01-01') FROM {{ this }})  
{% endif %}

