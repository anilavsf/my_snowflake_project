-- This test checks for anomalies where order dates are in the future.
-- Rule: The test fails if this query returns ANY rows.
select
    customer_id,
    first_order_date
from {{ ref('dim_customers') }}
where first_order_date > current_date()