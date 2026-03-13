WITH campaign AS (
    SELECT * FROM {{ ref('transformed_campaign_data') }}
)
SELECT 
    {{ dbt_utils.generate_surrogate_key(['CAMPAIGN_ID']) }} as CAMPAIGN_KEY,
    CAMPAIGN_ID,
    AUDIENCE_SEGMENT,
    BUDGET,
    CAMPAIGN_DURATION,
    ROI_CALCULATION,
    START_DATE,
    END_DATE
FROM campaign