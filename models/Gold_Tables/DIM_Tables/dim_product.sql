WITH product AS (
    SELECT * FROM {{ ref('transformed_product_data') }}
)
SELECT 
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID']) }} as PRODUCT_KEY,
    PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY,
    SUBCATEGORY,
    BRAND,
    COLOR,
    SIZE,
    UNIT_PRICE,
    COST_PRICE,
    SUPPLIER_ID
FROM product