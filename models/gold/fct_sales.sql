{{ config(
    materialized='table'
) }}

with orders as (
    select * from {{ ref('orders_clean') }}
),

customers as (
    select * from {{ ref('customers_clean') }}
),

products as (
    select * from {{ ref('products_clean') }}
),

joined_data as (
    select
        o.order_id,
        o.order_date,
        o.customer_id,
        c.customer_name,
        c.customer_segment,
        c.country,

        o.product_id,
        p.product_name,
        p.category,
        p.sub_category,

        o.quantity,
        o.net_sales,
        o.adjusted_profit,
        o.profit_margin,
        o.market

    from orders o
    join customers c 
        on o.customer_id = c.customer_id
    join products p 
        on o.product_id = p.product_id
)

select * from joined_data