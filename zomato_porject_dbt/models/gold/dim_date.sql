{{
  config(
    materialized = 'table',
    unique_key = 'date_day',
    alias = 'dim_date'
    )
}}
WITH spine AS (
    SELECT
        EXPLODE(
            SEQUENCE(
                DATE('2024-01-01'),
                DATE('2027-04-14'),
                INTERVAL 1 DAY
            )
        ) AS date_day
)

SELECT 
    *,
    year(date_day) AS date_year,
    month(date_day) AS date_month,
    monthname(date_day) AS date_month_name,
    dayname(date_day) AS date_day_name,
    CASE
        WHEN dayofweek(date_day) IN (1,7) THEN TRUE
        ELSE FALSE
    END AS is_weekend
FROM spine
WHERE date_day <= '2027-04-14'