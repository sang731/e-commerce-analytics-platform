{{config(
    unique_key='product_id',
    cluster_by=['category','sub_category']
)}}

select
    product_id,product_name,category,sub_category,market,load_time
from {{ref('stg_products')}}

where is_duplicate='N'

{% if is_incremental() %}
and load_time > (select max(load_time) from {{this}})
{% endif %}