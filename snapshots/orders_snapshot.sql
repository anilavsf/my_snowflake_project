{% snapshot orders_snapshot %}

{{
    config(
      target_database='dbt_demo',
      target_schema='demo_schema',
      unique_key='order_id',
      strategy='check',
      check_cols=['status'],
    )
}}

select * from {{ ref('stg_orders') }}

{% endsnapshot %}