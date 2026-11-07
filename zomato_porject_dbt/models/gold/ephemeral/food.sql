{{
  config(
    materialized = 'ephemeral',
    )
}}

with food as(
    SELECT
        *
    FROM {{ ref('silver_food') }}
)

SELECT
    *
FROM food