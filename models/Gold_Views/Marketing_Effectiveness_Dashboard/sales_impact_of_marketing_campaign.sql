SELECT 
    CAMPAIGN_ID,
    CAST(START_DATE AS DATE) AS START_DATE,
    CAST(END_DATE AS DATE) AS END_DATE,
    F.TOTAL_SALES_BY_CAMPAIGN,
FROM {{ ref('fact_marketing_performance') }} F
RIGHT JOIN {{ ref('dim_marketingcampaign') }} C
    ON C.CAMPAIGN_KEY = F.CAMPAIGN_KEY