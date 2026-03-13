WITH raw_source AS (
    SELECT * FROM {{ source('raw_sources_before_snapshot', 'orders_data_ex') }}
)
 
SELECT
    f.value:order_id::STRING AS order_id,
    f.value:customer_id::STRING AS customer_id,
    f.value:store_id::STRING AS store_id,
    f.value:employee_id::STRING AS employee_id,
    f.value:campaign_id::STRING AS campaign_id,
    f.value:order_status::STRING AS order_status,
    f.value:order_source::STRING AS order_source,
    f.value:payment_method::STRING AS payment_method,
    f.value:shipping_method::STRING AS shipping_method,
    f.value:total_amount::FLOAT AS total_amount,
    f.value:discount_amount::FLOAT AS total_discount,
    f.value:shipping_cost::FLOAT AS shipping_cost,
    f.value:tax_amount::FLOAT AS tax_amount,
    f.value:order_date::TIMESTAMP_TZ AS order_date,
    f.value:created_at::TIMESTAMP_TZ AS created_at,
    f.value:shipping_date::TIMESTAMP_TZ AS shipping_date,
    f.value:delivery_date::TIMESTAMP_TZ AS delivery_date,
    f.value:estimated_delivery_date::TIMESTAMP_TZ AS estimated_delivery_date,
    f.value:shipping_address.street::STRING AS shipping_street,
    f.value:shipping_address.city::STRING AS shipping_city,
    f.value:shipping_address.state::STRING AS shipping_state,
    f.value:shipping_address.zip_code::STRING AS shipping_zip,
    f.value:billing_address.street::STRING AS billing_street,
    f.value:billing_address.city::STRING AS billing_city,
    f.value:billing_address.state::STRING AS billing_state,
    f.value:billing_address.zip_code::STRING AS billing_zip
FROM raw_source,
LATERAL FLATTEN(input => value:orders_data) f