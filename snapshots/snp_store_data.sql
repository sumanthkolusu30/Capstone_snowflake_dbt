{% snapshot snp_store_data %}
 
{{
    config(
      target_database='CAPSTONE_PROJECT',
      target_schema='BRONZE',
      unique_key='store_id',
      strategy='timestamp',
      updated_at='last_modified_date',
    )
}}
 
SELECT * FROM {{ ref('flatened_store_data') }}
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY store_id
    ORDER BY last_modified_date DESC
) = 1
 
{% endsnapshot %}