WITH raw_source AS (
    SELECT * FROM {{ source('raw_sources_before_snapshot', 'store_data_ex') }}
)
 
SELECT
    f.value:store_id::STRING AS store_id,
    f.value:store_name::STRING AS store_name,
    f.value:region::STRING AS region,
    f.value:store_type::STRING AS store_type,
    f.value:manager_id::STRING AS manager_id,
    f.value:phone_number::STRING AS phone_number,
    f.value:email::STRING AS email,
    f.value:address.street::STRING AS street,
    f.value:address.city::STRING AS city,
    f.value:address.zip_code::STRING AS zip_code,
    f.value:address.country::STRING AS country,
    f.value:operating_hours.weekdays::STRING AS hours_weekdays,
    f.value:operating_hours.weekends::STRING AS hours_weekends,
    f.value:operating_hours.holidays::STRING AS hours_holidays,
    f.value:size_sq_ft::INT AS size_sq_ft,
    f.value:employee_count::INT AS employee_count,
    f.value:monthly_rent::FLOAT AS monthly_rent,
    f.value:sales_target::FLOAT AS sales_target,
    f.value:current_sales::FLOAT AS current_sales,
    f.value:is_active::BOOLEAN AS is_active,
    f.value:opening_date::DATE AS opening_date,
    f.value:last_modified_date::DATE AS last_modified_date,
    f.value:services::VARIANT AS services
FROM raw_source,
LATERAL FLATTEN(input => value:stores_data) f