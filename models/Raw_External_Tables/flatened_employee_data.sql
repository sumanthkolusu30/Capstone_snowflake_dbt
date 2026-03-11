WITH raw_source AS (
    SELECT * FROM {{ source('raw_sources_before_snapshot', 'employee_data_ex') }}
)
 
SELECT
f.value:employee_id::STRING AS employee_id,
f.value:first_name::STRING AS first_name,
f.value:last_name::STRING AS last_name,
f.value:email::STRING AS email,
f.value:phone::STRING AS phone,
f.value:role::STRING AS role,
f.value:department::STRING AS department,
f.value:work_location::STRING AS work_location,
f.value:manager_id::STRING AS manager_id,
f.value:employment_status::STRING AS employment_status,
f.value:education::STRING AS education,
f.value:hire_date::DATE AS hire_date,
f.value:date_of_birth::DATE AS date_of_birth,
f.value:last_modified_date::DATE AS last_modified_date,
f.value:salary::FLOAT AS salary,
f.value:sales_target::FLOAT AS sales_target,
f.value:current_sales::FLOAT AS current_sales,
f.value:performance_rating::FLOAT AS performance_rating,
f.value:address.street::STRING AS street,
f.value:address.city::STRING AS city,
f.value:address.state::STRING AS state,
f.value:address.zip_code::STRING AS zip_code,
f.value:certifications::VARIANT AS certifications

FROM raw_source,
LATERAL FLATTEN(input => value:employees_data) f