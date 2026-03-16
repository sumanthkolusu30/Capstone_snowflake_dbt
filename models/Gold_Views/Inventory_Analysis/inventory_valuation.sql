
SELECT 
    INVENTORY_KEY,
    PRODUCT_ID,
    FULL_DATE,
    STORE_ID,
    SU.SUPPLIER_ID,
    INVENTORY_VALUE
FROM {{ ref('fact_inventory') }} I
LEFT JOIN {{ ref('dim_product') }} P
    ON P.PRODUCT_KEY = I.PRODUCT_KEY
LEFT JOIN {{ ref('dim_date') }} D
    ON D.DATE_KEY = I.DATE_KEY
LEFT JOIN {{ ref('dim_store') }} S
    ON S.STORE_KEY = I.STORE_KEY
LEFT JOIN {{ ref('dim_supplier') }} SU
    ON SU.SUPPLIER_KEY = I.SUPPLIER_KEY