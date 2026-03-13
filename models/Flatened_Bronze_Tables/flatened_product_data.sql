WITH raw_source AS (
    SELECT * FROM {{ source('raw_sources_before_snapshot', 'product_data_ex') }}
)
 
SELECT
f.value:product_id::STRING AS product_id,
f.value:name::STRING AS product_name,
f.value:brand::STRING AS brand,
f.value:supplier_id::STRING AS supplier_id,
f.value:category::STRING AS category,
f.value:subcategory::STRING AS subcategory,
f.value:product_line::STRING AS product_line,
f.value:short_description::STRING AS short_description,
f.value:technical_specs::STRING AS technical_specs,
f.value:color::STRING AS color,
f.value:size::STRING AS size,
f.value:weight::STRING AS weight,
f.value:dimensions::STRING AS dimensions,
f.value:warranty_period::STRING AS warranty_period,
f.value:unit_price::FLOAT AS unit_price,
f.value:cost_price::FLOAT AS cost_price,
f.value:stock_quantity::INT AS stock_quantity,
f.value:reorder_level::INT AS reorder_level,
f.value:is_featured::BOOLEAN AS is_featured,
f.value:launch_date::DATE AS launch_date,
f.value:last_modified_date::DATE AS last_modified_date
FROM raw_source,
LATERAL FLATTEN(input => value:products_data) f