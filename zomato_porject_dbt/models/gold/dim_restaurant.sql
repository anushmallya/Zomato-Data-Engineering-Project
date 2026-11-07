SELECT
    * EXCEPT(
        `restaurant_updated_datetime`,
        `dbt_scd_id`,
        `dbt_updated_at`,
        `dbt_valid_from`,
        `dbt_valid_to`),
    CASE
        WHEN `dbt_valid_to` IS NULL THEN 'Active'
        ELSE 'Inactive'
    END as `active_status`  
FROM {{ ref("snap_dim_restaurant") }}