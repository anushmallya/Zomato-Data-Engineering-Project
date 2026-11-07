{{
  config(
    materialized = 'ephemeral',
    )
}}
WITH restaurant as(
    SELECT DISTINCT
        *
    FROM {{ ref('silver_restaurant') }}
)

SELECT
    *
FROM restaurant