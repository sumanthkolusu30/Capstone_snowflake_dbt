SELECT 
    {{ dbt_utils.generate_surrogate_key([
            'OI.ORDER_ID',
            'O.CUSTOMER_ID',
            'OI.PRODUCT_ID',
            'O.STORE_ID',
            'CAST(O.ORDER_DATE AS DATE)',
            'O.EMPLOYEE_ID',
            'O.CAMPAIGN_ID']) }} as SALES_KEY,
    OI.ORDER_ID,
    C.CUSTOMER_KEY,
    P.PRODUCT_KEY,
    S.STORE_KEY,
    DAT.DATE_KEY,
    {{ dbt_utils.generate_surrogate_key(['O.EMPLOYEE_ID']) }} as EMPLOYEE_KEY,
    {{ dbt_utils.generate_surrogate_key(['O.CAMPAIGN_ID']) }} as CAMPAIGN_KEY,
    OI.QUANTITY AS QUANTITY_SOLD,
    OI.UNIT_PRICE,
    (OI.QUANTITY*OI.UNIT_PRICE) AS TOTAL_SALES_AMOUNT,
    (OI.QUANTITY*P.COST_PRICE) AS COST_AMOUNT,
    ((OI.QUANTITY*OI.UNIT_PRICE)
        - (OI.QUANTITY*P.COST_PRICE)
        - COALESCE(OI.DISCOINT_AMOUNT,0)
        - COALESCE(O.SHIPPING_COST,0) ) AS PROFIT_AMOUNT,
    COALESCE(OI.DISCOINT_AMOUNT,0) AS DISCOUNT_AMOUNT,
    O.SHIPPING_COST,
    S.REGION,
    CASE 
        WHEN O.ORDER_SOURCE = 'In-Store' THEN 'In-Store'
    ELSE 'Online'
    END AS SALES_CHANNEL,
    C.CUSTOMER_SEGMENT    
FROM {{ ref('transformed_orders_items_data') }} OI
LEFT JOIN {{ ref('transformed_orders_data') }} O
    ON OI.ORDER_ID = O.ORDER_ID
LEFT JOIN {{ ref('dim_date') }} DAT 
    ON {{ dbt_utils.generate_surrogate_key(['CAST(O.ORDER_DATE AS DATE)']) }} 
        = DAT.DATE_KEY
LEFT JOIN {{ ref('dim_product') }} P 
    ON {{ dbt_utils.generate_surrogate_key(['OI.PRODUCT_ID']) }} 
        = P.PRODUCT_KEY
LEFT JOIN {{ ref('dim_store') }} S 
    ON {{ dbt_utils.generate_surrogate_key(['O.STORE_ID']) }} 
        = S.STORE_KEY
LEFT JOIN {{ ref('dim_customers') }} C 
    ON {{ dbt_utils.generate_surrogate_key(['O.CUSTOMER_ID']) }}    
        = C.CUSTOMER_KEY