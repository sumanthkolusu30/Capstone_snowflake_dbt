WITH employee AS (
    SELECT * FROM {{ ref('transformed_employee_data') }}
)
SELECT 
    {{ dbt_utils.generate_surrogate_key(['EMPLOYEE_ID']) }} as EMPLOYEE_KEY,
    EMPLOYEE_ID,
    FULL_NAME,
    ROLE,
    WORK_LOCATION,
    TENURE,
    CASE    
        WHEN IS_EMAIL_VALID = 'Valid' THEN EMAIL
    ELSE NULL
    END AS EMAIL,
    ORDERS_PROCESSED,
    TOTAL_SALES_AMOUNT,
    PHONE,
    PERFORMANCE_RATING
FROM employee