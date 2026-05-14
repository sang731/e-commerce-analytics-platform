select *, case when duplicate_rank>1 then 'Y' else 'N' end as is_duplicate from (
    select
        raw_data:"Order ID"::string as order_id,
        raw_data:"Customer ID"::string as customer_id,
        raw_data:"Product ID"::string as product_id,
        coalesce(
            try_to_date(raw_data:"Order Date"::string,'YYYY-MM-DD'),
            try_to_date(raw_data:"Order Date"::string,'DD-MM-YYYY'))
        as order_date,
        raw_data:"Order Priority"::string as order_priority,
        raw_data:"Country"::string as country,
        raw_data:"Region"::string as region,
        raw_data:"Sales"::float as sales,
        raw_data:"Quantity"::int as quantity,
        raw_data:"Discount"::float as discount,
        raw_data:"Profit"::float as profit,
        coalesce(
            try_to_date(raw_data:"Order Date"::string,'YYYY-MM-DD'),
            try_to_date(raw_data:"Order Date"::string,'DD-MM-YYYY'))
        as ship_date,
        raw_data:"Ship Mode"::string as ship_mode,
        raw_data:"Shipping Cost"::float as shipping_cost,
        raw_data:"Market"::string as market,
        case when raw_data:"Order Date" is null then 'Y' else 'N' end as order_date_null,
        
            row_number() over (
                partition by raw_data:"Order ID"::string
                order by load_time desc
            ) as duplicate_rank,
        load_time
    from {{ source('bronze','raw_orders') }}
    where raw_data:"Order ID" is not null and raw_data:"Customer ID" is not null and raw_data:"Product ID" is not null
)