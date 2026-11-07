{{
    config(
        materialized='incremental',
        unique_key='user_id',
        incremental_strategy='merge',
        alias='users'
    )
}}

WITH source_data AS (
    SELECT
        * EXCEPT (`_rescued_data`,
            `Marital Status`,
            `Monthly Income`,
            `Educational Qualifications`,
            `Family size`
        ),

        `Marital Status` AS marital_status,
        `Monthly Income` AS monthly_income,
        `Educational Qualifications` AS educational_qualifications,
        `Family size` AS family_size
    FROM read_files(
        '/Volumes/zomato_dep/source/source_data/users.csv.gz',
        format => 'csv',
        header => true,
        multiLine => true,
        inferColumnTypes => false
    )
),
source_hashed AS (
    SELECT
        *,
        sha2(
            to_json(struct(*)),
            256
        ) AS row_hash
    FROM source_data
),
changed_rows AS (
    SELECT *
    FROM source_hashed
    {% if is_incremental() %}
    WHERE NOT EXISTS (
        SELECT 1
        FROM {{ this }} AS target
        WHERE target.user_id = source_hashed.user_id
          AND target.row_hash = source_hashed.row_hash
    )
    {% endif %}
)

SELECT
    *,
    current_timestamp() AS source_ingest_time
FROM changed_rows
