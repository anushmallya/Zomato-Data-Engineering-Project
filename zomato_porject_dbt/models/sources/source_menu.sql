{{
    config(
        materialized='incremental',
        unique_key=['menu_id','f_id'],
        incremental_strategy='merge',
        alias='menu'
    )
}}

WITH source_data AS (
    SELECT
        * EXCEPT(_rescued_data)
    FROM read_files(
        '/Volumes/zomato_dep/source/source_data/menu.csv.gz',
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
        WHERE target.f_id = source_hashed.f_id
          AND target.menu_id = source_hashed.menu_id
          AND target.row_hash = source_hashed.row_hash
    )
    {% endif %}
)

SELECT
    *,
    current_timestamp() AS source_ingest_time
FROM changed_rows
