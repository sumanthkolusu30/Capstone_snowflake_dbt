WITH store AS (
    SELECT * FROM {{ ref('transformed_store_data') }}
)
SELECT 
    {{ dbt_utils.generate_surrogate_key(['STORE_ID']) }} as STORE_KEY,
    STORE_ID,
    STORE_NAME,
    STREET,
    CITY,
    COUNTRY,
    ZIP_CODE,
    REGION,
    STORE_TYPE,
    OPENING_DATE,
    SIZE_CATEGORY    
FROM store