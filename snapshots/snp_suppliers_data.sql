{% snapshot snp_suppliers_data %}
 
{{
    config(
      target_database='CAPSTONE_PROJECT',
      target_schema='BRONZE',
      unique_key='supplier_id',
      strategy='timestamp',
      updated_at='last_modified_date',
    )
}}
 
SELECT * FROM {{ ref('flatened_supplier_data') }}
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY supplier_id
    ORDER BY last_modified_date DESC
) = 1
 
{% endsnapshot %}