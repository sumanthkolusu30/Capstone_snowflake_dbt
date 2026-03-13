WITH customer AS (
    SELECT * FROM {{ ref('transformed_customer_data') }}
)
SELECT 
    {{ dbt_utils.generate_surrogate_key(['CUSTOMER_ID']) }} as CUSTOMER_KEY,
    CUSTOMER_ID,
    FULL_NAME,
    CASE
        WHEN IS_EMAIL_VALID = 'Valid' THEN EMAIL
    ELSE NULL
    END AS EMAIL,
    PHONE,
    STREET,
    CITY,
    STATE,
    ZIP_CODE,
    COUNTRY,
    BIRTH_DATE,
    AGE,
    CUSTOMER_SEGMENT,
    OCCUPATION,
    INCOME_BRACKET,
    REGISTRATION_DATE,
    DBT_VALID_TO    
FROM customer