{{ config(materialized='table') }}

with base as (
    select 
        order_date,
        market,
        net_sales,
        adjusted_profit,
        order_id
    from {{ ref('fct_sales') }}
),

aggregated as (
    select
        order_date,
        market,
        sum(net_sales) as total_sales,
        sum(adjusted_profit) as total_profit,
        count(distinct order_id) as total_orders
    from base
    group by order_date, market
),

final as (
    select
        *,
        sum(total_sales) over (
            partition by market 
            order by order_date
            rows between unbounded preceding and current row
        ) as cumulative_sales
    from aggregated
)

select * from final