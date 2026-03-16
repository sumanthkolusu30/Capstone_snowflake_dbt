WITH cte_prod_sales AS (
    SELECT 
        PRODUCT_KEY,
        SUM(TOTAL_SALES_AMOUNT) AS TOTAL_SALES_AMOUNT
    FROM {{ ref('fact_sales') }} 
    GROUP BY PRODUCT_KEY
)
SELECT
    p.PRODUCT_NAME,
    TOTAL_SALES_AMOUNT
FROM cte_prod_sales c
LEFT JOIN {{ ref('dim_product') }} p 
    ON c.PRODUCT_KEY = p.PRODUCT_KEY
ORDER BY TOTAL_SALES_AMOUNT DESC