{{
config(
    materialized='table',
    tags=['dim', 'customer'],
    description='This table contains customer information along with their order history.'
)
}}

with customers as (
    select * from {{ ref('stg_customers') }}
),
orders as (
    select * from {{ ref('stg_orders') }}
),
customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        -- Dynamic Jinja Loop to pivot status counts
        {% set order_statuses = ['completed', 'shipped', 'returned'] %}
        {% for status in order_statuses %}
        sum(case when status = '{{ status }}' then 1 else 0 end) as {{ status }}_orders{% if not loop.last %},{% endif %}
        {% endfor %}
    from orders
    group by 1
),
final as (
    select
        customers.customer_id,
        customers.clean_first_name,
        customers.clean_last_name,
        coalesce(customer_orders.number_of_orders, 0) as total_orders,
        coalesce(customer_orders.completed_orders, 0) as completed_orders,
        coalesce(customer_orders.shipped_orders, 0) as shipped_orders,
        coalesce(customer_orders.returned_orders, 0) as returned_orders,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date
    from customers
    left join customer_orders using (customer_id)
)
select * from final