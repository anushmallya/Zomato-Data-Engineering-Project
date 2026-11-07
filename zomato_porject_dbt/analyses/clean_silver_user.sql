SELECT
    CAST(user_id AS INT) AS `customer_id`,
    name AS `customer_name`,
    LOWER(email) AS `customer_email`,
    CAST(Age AS INT) AS `customer_age`,
    Gender AS `customer_gender`,
    Occupation AS `customer_occupation`,
    marital_status AS `customer_marital_status`,
    monthly_income AS `customer_monthly_income`,
    educational_qualifications AS `customer_education`,
    CAST(family_size AS INT) AS `customer_family_size`,
    source_ingest_time AS `customer_updated_datetime`
FROM {{ ref('bronze_users') }}
WHERE user_id IS NOT NULL