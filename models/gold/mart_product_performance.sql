{{ config(materialized='table') }}

with base as (
    select
        product_name,
        category,
        sub_category,
        quantity,
        net_sales,
        adjusted_profit
    from {{ ref('fct_sales') }}
),

aggregated as (
    select
        product_name,
        category,
        sub_category,
        sum(quantity) as total_units_sold,
        sum(net_sales) as revenue,
        sum(adjusted_profit) as profit
    from base
    group by product_name, category, sub_category
),

final as (
    select
        *,
        revenue / sum(revenue) over () as revenue_share
    from aggregated
)

select * from final