use warehouse compute_wh;
use database ecommerce_db;
use schema silver;

show parameters like 'USE_CACHED_RESULT';

alter warehouse compute_wh resume;

alter table customers_clean modify column customer_name set masking policy customer_name_masked;

select * from orders_clean;
select * from customers_clean;
select * from products_clean;