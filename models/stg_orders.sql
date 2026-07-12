with source_data as (
    select * from {{ source('local_raw_data', 'orders') }}
)
    select
        id as order_id,
        customer_id,
        order_date,
        status
    from source_data