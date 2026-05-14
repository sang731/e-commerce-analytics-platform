
select * from {{ ref('stg_orders') }}
where quantity<0