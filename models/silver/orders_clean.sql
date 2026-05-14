{{config(
    unique_key='order_id',
    cluster_by=['order_date','market'],
)}}

select 
    order_id,customer_id,product_id,order_date,order_priority,country,region,quantity,sales,discount,profit,
    shipping_cost,ship_date,ship_mode,market,
    
    (sales-discount) as net_sales,(sales-discount-shipping_cost) as adjusted_profit, 
    (profit/nullif((sales-discount),0)) as profit_margin,((sales-discount)/nullif(quantity,0)) as avg_selling_price,

    year(order_date) as order_year,month(order_date) as order_month,day(order_date) as order_day,load_time
from {{ref('stg_orders')}}

where order_date_null='N' and is_duplicate='N'

{% if is_incremental() %}
and load_time>(select max(load_time) from {{this}})
{% endif %}