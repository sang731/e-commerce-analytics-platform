use warehouse data_load_wh;
use database ecommerce_db;
use schema bronze;

create or replace table raw_orders(
    raw_data variant,
    source_file string,
    file_row_number number,
    load_time timestamp default current_timestamp()
);
create or replace table raw_customers like raw_orders;
create or replace table raw_products like raw_orders;

show tables like 'raw%';

create or replace storage integration s3_storage
type=external_stage
storage_provider=s3
enabled=true
storage_aws_role_arn='arn:aws:iam::<account-id>:role/<role-name>'
storage_allowed_locations=('s3://poc-demo-awss3-bucket');

desc integration s3_storage;

create or replace stage ecommerce_external_stage
url='s3://poc-demo-awss3-bucket'
storage_integration=s3_storage;

list @ecommerce_external_stage;

create or replace file format csv_file_format
type='CSV'
field_delimiter=','
field_optionally_enclosed_by='"'
skip_header=1;

create or replace file format json_file_format
type='JSON'
strip_outer_array=true
ignore_utf8_errors=true;

create or replace file format parquet_file_format
type='parquet'
compression='snappy'
binary_as_text=false;

show file formats;

create or replace pipe us_orders_pipe
auto_ingest=true as
copy into raw_orders(raw_data,source_file,file_row_number) from 
(select OBJECT_CONSTRUCT('Order ID',$1,'Customer ID',$2,'Product ID',$3,'Order Date',$4,'Order Priority',$5,'Country',$6,'Region',$7,'Sales',$8,'Quantity',$9,'Discount',$10,'Profit',$11,'Ship Date',$12,'Ship Mode',$13,'Shipping Cost',$14,'Market',$15),metadata$filename,metadata$file_row_number from @ecommerce_external_stage/us-data)
pattern='.*orders.*\\.csv'
on_error='continue'
file_format=csv_file_format;

select system$pipe_status('us_orders_pipe');
alter pipe us_orders_pipe set pipe_execution_paused=false;

create or replace pipe us_customers_pipe
auto_ingest=true as
copy into raw_customers(raw_data,source_file,file_row_number) from 
(select OBJECT_CONSTRUCT('Customer ID',$1,'Customer Name',$2,'Customer Segment',$3,'Country',$4,'City',$5,'State',$6,'Region',$7,'Market',$8),metadata$filename,metadata$file_row_number from @ecommerce_external_stage/us-data)
pattern='.*customers.*\\.csv'
on_error='continue'
file_format=csv_file_format;

select system$pipe_status('us_customers_pipe');
alter pipe us_customers_pipe set pipe_execution_paused=false;

create or replace pipe us_products_pipe
auto_ingest=true as
copy into raw_products(raw_data,source_file,file_row_number) from 
(select OBJECT_CONSTRUCT('Product ID',$1,'Product Name',$2,'Category',$3,'Sub-Category',$4,'Market',$5),metadata$filename,metadata$file_row_number from @ecommerce_external_stage/us-data)
pattern='.*products.*\\.csv'
on_error='continue'
file_format=csv_file_format;

select system$pipe_status('us_products_pipe');
alter pipe us_products_pipe set pipe_execution_paused=false;

create pipe eu_orders_pipe
auto_ingest=true as
copy into raw_orders(raw_data,source_file,file_row_number) from (select $1,metadata$filename,metadata$file_row_number from @ecommerce_external_stage/eu-data)
pattern='.*orders.*\\.json'
on_error='continue'
file_format=json_file_format;

select system$pipe_status('eu_orders_pipe');
alter pipe eu_orders_pipe set pipe_execution_paused=false;

create pipe eu_customers_pipe
auto_ingest=true as
copy into raw_customers(raw_data,source_file,file_row_number) from (select $1,metadata$filename,metadata$file_row_number from @ecommerce_external_stage/eu-data)
pattern='.*customers.*\\.json'
on_error='continue'
file_format=json_file_format;

select system$pipe_status('eu_customers_pipe');
alter pipe eu_customers_pipe set pipe_execution_paused=false;

create pipe eu_products_pipe
auto_ingest=true as
copy into raw_products(raw_data,source_file,file_row_number) from (select $1,metadata$filename,metadata$file_row_number from @ecommerce_external_stage/eu-data)
pattern='.*products.*\\.json'
on_error='continue'
file_format=json_file_format;

select system$pipe_status('eu_products_pipe');
alter pipe eu_products_pipe set pipe_execution_paused=false;

create pipe apac_orders_pipe
auto_ingest=true as
copy into raw_orders(raw_data,source_file,file_row_number) from (select $1,metadata$filename,metadata$file_row_number from @ecommerce_external_stage/apac-data)
pattern='.*orders.*\\.parquet'
on_error='continue'
file_format=parquet_file_format;

select system$pipe_status('apac_orders_pipe');
alter pipe apac_orders_pipe set pipe_execution_paused=false;

create pipe apac_customers_pipe
auto_ingest=true as
copy into raw_customers(raw_data,source_file,file_row_number) from (select $1,metadata$filename,metadata$file_row_number from @ecommerce_external_stage/apac-data)
pattern='.*customers.*\\.parquet'
on_error='continue'
file_format=parquet_file_format;

select system$pipe_status('apac_customers_pipe');
alter pipe apac_customers_pipe set pipe_execution_paused=false;

create pipe apac_products_pipe
auto_ingest=true as
copy into raw_products(raw_data,source_file,file_row_number) from (select $1,metadata$filename,metadata$file_row_number from @ecommerce_external_stage/apac-data)
pattern='.*products.*\\.parquet'
on_error='continue'
file_format=parquet_file_format;

select system$pipe_status('apac_products_pipe');
alter pipe apac_products_pipe set pipe_execution_paused=false;

show pipes;

alter pipe us_orders_pipe refresh;
alter pipe us_customers_pipe refresh;
alter pipe us_products_pipe refresh;
alter pipe eu_orders_pipe refresh;
alter pipe eu_customers_pipe refresh;
alter pipe eu_products_pipe refresh;
alter pipe apac_orders_pipe refresh;
alter pipe apac_customers_pipe refresh;
alter pipe apac_products_pipe refresh;

alter warehouse data_load_wh resume;
select * from raw_orders;
select * from raw_customers;
select * from raw_products;