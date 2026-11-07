{% set incremental_col_1, incremental_col_2 =  'source_ingest_time','customer_updated_datetime' %}

{{
  config(
    materialized = 'incremental',
    alias = 'users',
    unique_key = 'customer_id',
    incremental_strategy='merge'
    )
}}

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
{% if is_incremental() %}
  AND {{incremental_col_1}} > (SELECT COALESCE(MAX({{incremental_col_2}}), '1900-01-01') FROM {{this}})
{% endif %}