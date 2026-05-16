use warehouse compute_wh;
use database ecommerce_db;
use schema gold;

alter warehouse compute_wh resume;

show tables;

alter table fct_sales modify column net_sales set masking policy mask_revenue;

alter table mart_daily_sales_by_region modify column total_sales set masking policy mask_revenue;
alter table mart_daily_sales_by_region modify column total_profit set masking policy mask_revenue;
alter table mart_daily_sales_by_region modify column cumulative_sales set masking policy mask_revenue;

alter table mart_product_performance modify column revenue_share set masking policy mask_revenue;