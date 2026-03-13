WITH CTE_DATES AS (
    {{ dbt_date.get_date_dimension("2015-01-01", "2035-12-31") }}
),
FINAL AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['date_day']) }} as DATE_KEY,
        date_day AS FULL_DATE,
        year_number AS YEAR,
        quarter_of_year AS QUARTER,
        month_of_year AS MONTH,
        week_of_year AS WEEK,
        day_of_week AS DAY_OF_WEEK,
        CASE 
            WHEN month_of_year IN (12, 1, 2) THEN 'Winter'
            WHEN month_of_year IN (3, 4, 5) THEN 'Spring'
            WHEN month_of_year IN (6, 7, 8) THEN 'Summer'
            WHEN month_of_year IN (9, 10, 11) THEN 'Fall'
        END AS SEASON
    FROM CTE_DATES
)
SELECT *
FROM FINAL