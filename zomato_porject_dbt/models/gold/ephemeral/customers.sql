{{
  config(
    materialized = 'ephemeral',
    )
}}
WITH customers as(
    SELECT
        customer_id,
        customer_name,
        customer_email,
        customer_age,
        CASE
            WHEN customer_age < 25 THEN 'Gen Z'
            WHEN customer_age <40 THEN 'Millennial'
            WHEN customer_age < 55 THEN 'Gen X'
            WHEN customer_age IS NULL THEN 'Unknown'
            ELSE 'Boomer'
        END as customer_generation,
        customer_gender,
        customer_marital_status,
        customer_occupation,
        customer_monthly_income,
        customer_education,
        customer_family_size,
        customer_updated_datetime
    FROM {{ ref('silver_user') }}
)

SELECT
    *
FROM customers