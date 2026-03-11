WITH raw_source AS (
    SELECT * FROM {{ source('raw_sources_before_snapshot', 'supplier_data_ex') }}
)
 
SELECT
    f.value:supplier_id::STRING AS supplier_id,
    f.value:supplier_name::STRING AS supplier_name,
    f.value:supplier_type::STRING AS supplier_type,
    f.value:payment_terms::STRING AS payment_terms,
    f.value:credit_rating::STRING AS credit_rating,
    f.value:tax_id::STRING AS tax_id,
    f.value:website::STRING AS website,
    f.value:contact_information.contact_person::STRING AS contact_person,
    f.value:contact_information.email::STRING AS contact_email,
    f.value:contact_information.phone::STRING AS contact_phone,
    f.value:contact_information.address::STRING AS full_address,
    f.value:contract_details.contract_id::STRING AS contract_id,
    f.value:contract_details.start_date::DATE AS contract_start_date,
    f.value:contract_details.end_date::DATE AS contract_end_date,
    f.value:contract_details.renewal_option::BOOLEAN AS renewal_option,
    f.value:contract_details.exclusivity::BOOLEAN AS exclusivity,
    f.value:performance_metrics.on_time_delivery_rate::FLOAT AS on_time_delivery_rate,
    f.value:performance_metrics.average_delay_days::FLOAT AS avg_delay_days,
    f.value:performance_metrics.defect_rate::FLOAT AS defect_rate,
    f.value:performance_metrics.returns_percentage::FLOAT AS returns_pct,
    f.value:performance_metrics.quality_rating::STRING AS quality_rating,
    f.value:performance_metrics.response_time_hours::INT AS response_time_hours,
    f.value:lead_time_days::INT AS lead_time_days,
    f.value:minimum_order_quantity::INT AS minimum_order_quantity,
    f.value:preferred_carrier::STRING AS preferred_carrier,
    f.value:year_established::INT AS year_established,
    f.value:is_active::BOOLEAN AS is_active,
    f.value:last_order_date::DATE AS last_order_date,
    f.value:last_modified_date::DATE AS last_modified_date,
    f.value:categories_supplied::VARIANT AS categories_supplied
FROM raw_source,
LATERAL FLATTEN(input => value:suppliers_data) f