WITH cte_cust_first_order AS (
    SELECT 
        CUSTOMER_KEY,
        ORDER_DATE,
        CAMPAIGN_KEY,
        MIN(ORDER_DATE) OVER(PARTITION BY CUSTOMER_KEY) AS FIRST_PURCHASE_DATE,
        MAX(ORDER_DATE) OVER(PARTITION BY CUSTOMER_KEY) AS LAST_PURCHASE_DATE 
    FROM {{ ref('fact_sales') }} F
),
cte_flaging_new_cust AS (
    SELECT 
        F.CUSTOMER_KEY,
        F.ORDER_DATE,
        F.CAMPAIGN_KEY,
        F.FIRST_PURCHASE_DATE,
        F.LAST_PURCHASE_DATE,
        CASE 
            WHEN 
                FIRST_PURCHASE_DATE = ORDER_DATE
                AND 
                ORDER_DATE BETWEEN C.START_DATE AND C.END_DATE
            THEN 1
        ELSE 0 
        END AS FIRST_CUSTOMER
    FROM cte_cust_first_order F
    LEFT JOIN {{ ref('dim_marketingcampaign') }} C
        ON C.CAMPAIGN_KEY = F.CAMPAIGN_KEY
),
cte_new_cust_count AS (
    SELECT 
        CAMPAIGN_KEY,
        SUM(FIRST_CUSTOMER) AS NEW_CUSTOMERS
    FROM cte_flaging_new_cust
    GROUP BY CAMPAIGN_KEY
),
cte_repeat_cust_count AS (
    SELECT  
        CAMPAIGN_KEY,
        COUNT(DISTINCT CUSTOMER_KEY) AS REPEAT_CUSTOMERS
    FROM cte_flaging_new_cust
    WHERE FIRST_CUSTOMER = 1
        AND FIRST_PURCHASE_DATE <> LAST_PURCHASE_DATE
    GROUP BY CAMPAIGN_KEY
),
cte_total_sales_by_campaign AS (
    SELECT 
        C.CAMPAIGN_KEY,
        SUM(O.TOTAL_SALES_AMOUNT) AS TOTAL_SALES_BY_CAMPAIGN
    FROM GOLD.DIM_MARKETINGCAMPAIGN C
    LEFT JOIN {{ ref('fact_sales') }} O
        ON C.CAMPAIGN_KEY = O.CAMPAIGN_KEY
    WHERE O.ORDER_DATE BETWEEN C.START_DATE AND C.END_DATE
    GROUP BY C.CAMPAIGN_KEY
)
SELECT 
    nc.CAMPAIGN_KEY,
    nc.NEW_CUSTOMERS,
    (rc.REPEAT_CUSTOMERS*100.0)/nc.NEW_CUSTOMERS AS REPEAT_CUSTOMERS_RATE,
    ts.TOTAL_SALES_BY_CAMPAIGN,
    ((ts.TOTAL_SALES_BY_CAMPAIGN-mc.TOTAL_COST)/mc.TOTAL_COST)*100.0 AS ROI_METRICS
FROM cte_repeat_cust_count rc
RIGHT JOIN cte_new_cust_count nc
    ON nc.CAMPAIGN_KEY = rc.CAMPAIGN_KEY
RIGHT JOIN cte_total_sales_by_campaign ts
    ON ts.CAMPAIGN_KEY = nc.CAMPAIGN_KEY
RIGHT JOIN {{ ref('dim_marketingcampaign') }} mc
    ON mc.CAMPAIGN_KEY = nc.CAMPAIGN_KEY