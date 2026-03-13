WITH supplier AS (
    SELECT * FROM {{ ref('transformed_supplier_data') }}
)
SELECT 
    {{ dbt_utils.generate_surrogate_key(['SUPPLIER_ID']) }} as SUPPLIER_KEY,
    SUPPLIER_ID,
    SUPPLIER_NAME,
    CONTACT_PERSON,
    CONTACT_EMAIL,
    CONTACT_PHONE,
    FULL_ADDRESS,
    PAYMENT_TERMS,
    SUPPLIER_TYPE
FROM supplier