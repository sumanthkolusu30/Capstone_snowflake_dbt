WITH raw_source AS (
    SELECT * FROM {{ source('raw_sources_before_snapshot', 'customer_data_ex') }}
)

SELECT
    f.value:customer_id::STRING AS customer_id,
    f.value:first_name::STRING AS first_name,
    f.value:last_name::STRING AS last_name,
    f.value:email::STRING AS email,
    f.value:phone::STRING AS phone,
    f.value:birth_date::STRING AS birth_date,
    f.value:address.street::STRING AS street,
    f.value:address.city::STRING AS city,
    f.value:address.state::STRING AS state,
    f.value:address.zip_code::STRING AS zip_code,
    f.value:address.country::STRING AS country,
    f.value:registration_date::DATE AS registration_date,
    f.value:preferred_communication::STRING AS preferred_communication,
    f.value:occupation::STRING AS occupation,
    f.value:income_bracket::STRING AS income_bracket,
    f.value:loyalty_tier::STRING AS loyalty_tier,
    f.value:total_purchases::INT AS total_purchases,
    f.value:total_spend::FLOAT AS total_spend,
    f.value:preferred_payment_method::STRING AS preferred_payment_method,
    f.value:marketing_opt_in::BOOLEAN AS marketing_opt_in,
    f.value:last_purchase_date::DATE AS last_purchase_date,
    f.value:last_modified_date::DATE AS last_modified_date

FROM raw_source,
LATERAL FLATTEN(input => value:customers_data) f