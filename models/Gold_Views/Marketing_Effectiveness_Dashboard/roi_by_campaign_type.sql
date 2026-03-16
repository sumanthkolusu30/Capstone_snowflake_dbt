SELECT  
    MC.CAMPAIGN_TYPE,
    AVG(FC.ROI_METRICS) AS ROI_METRIC
FROM {{ ref('fact_marketing_performance') }} FC
JOIN {{ ref('dim_marketingcampaign') }} MC
    ON FC.CAMPAIGN_KEY = MC.CAMPAIGN_KEY
GROUP BY MC.CAMPAIGN_TYPE