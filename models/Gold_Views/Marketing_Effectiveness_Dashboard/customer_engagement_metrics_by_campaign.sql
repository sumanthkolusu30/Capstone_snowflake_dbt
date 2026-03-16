SELECT 
    CAMPAIGN_ID,
    NEW_CUSTOMERS,
    REPEAT_CUSTOMERS_RATE
FROM {{ ref('fact_marketing_performance') }} MP
RIGHT JOIN {{ ref('dim_marketingcampaign') }} C
    ON C.CAMPAIGN_KEY = MP.CAMPAIGN_KEY