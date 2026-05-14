{{ config(materialized='table') }}

with customer_spend as (
    select
        customer_id,
        customer_name,
        sum(net_sales) as total_spend,
        max(order_date) as last_order_date
    from {{ ref('fct_sales') }}
    group by customer_id, customer_name
),

ranked as (
    select
        *,
        rank() over (order by total_spend desc) as rnk
    from customer_spend
),

final as (
    select *
    from ranked
    where rnk <= 10
)

select * from final