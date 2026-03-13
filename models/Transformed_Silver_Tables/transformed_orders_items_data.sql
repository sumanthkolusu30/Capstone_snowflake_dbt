WITH order_items AS (
    SELECT * FROM {{ ref('flatened_order_items_data') }}
)
SELECT 
    ORDER_ID,
    COST_PRICE,
    DISCOINT_AMOUNT,
    PRODUCT_ID,
    QUANTITY,
    UNIT_PRICE
FROM order_items