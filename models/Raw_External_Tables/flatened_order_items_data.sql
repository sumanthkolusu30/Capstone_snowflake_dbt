WITH raw_source AS (
    SELECT * FROM {{ source('raw_sources_before_snapshot', 'orders_data_ex') }}
),

orders AS (
    SELECT
        f.value:order_id::STRING AS ORDER_ID,
        f.value:order_items::VARIANT AS ORDER_ITEMS
    FROM raw_source,
    LATERAL FLATTEN(input => value:orders_data) f
)
SELECT 
    ORDER_ID, 
    value:cost_price::FLOAT AS COST_PRICE,
    value:discount_amount::FLOAT AS DISCOINT_AMOUNT,
    value:product_id::STRING AS PRODUCT_ID,
    value:quantity::INT AS QUANTITY,
    value:unit_price::float AS UNIT_PRICE
FROM orders,
LATERAL FLATTEN(input => ORDER_ITEMS)
 
