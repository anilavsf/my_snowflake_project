with source_data as (
    select * from {{ source('local_raw_data', 'customers') }}
),

final as (
    select
        id as customer_id,
        upper(first_name) as clean_first_name,
        upper(last_name) as clean_last_name
    from source_data
)

select * from final