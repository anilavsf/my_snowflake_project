{{ config(
    materialized='incremental',
    unique_key='order_id',
    description='This table contains order information including order date and status.'
) 
}}

with source_data as (
    select * from {{ source('local_raw_data', 'orders') }}
)
    select
        id as order_id,
        customer_id,
        order_date,
        status
    from source_data

{% if is_incremental() %}
    where order_date > (select max(order_date) from {{ this }})
{% endif %}