{{config(
    unique_key='customer_id',
    cluster_by=['customer_segment','country']
)}}

select
    customer_id,initcap(customer_name) as customer_name,upper(customer_segment) as customer_segment,country,city,state, 
    region,market,load_time
from {{ref('stg_customers')}}

where is_duplicate='N'

{% if is_incremental() %}
and load_time > (select max(load_time) from {{this}})
{% endif %}