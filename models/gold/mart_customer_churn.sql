{{ config(
    materialized='table'
) }}

with customer_activity as (
    select
        customer_id,
        customer_name,
        max(order_date) as last_order_date
    from {{ ref('fct_sales') }}
    group by customer_id, customer_name
),

calculated as (
    select
        *,
        datediff(day, last_order_date,'2014-12-31') as days_inactive
    from customer_activity
),

final as (
    select
        *,
        case
            when days_inactive > 90 then 'churned'
            else 'active'
        end as churn_status
    from calculated
)

select * from final