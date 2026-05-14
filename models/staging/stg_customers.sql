select *, case when duplicate_rank>1 then 'Y' else 'N' end as is_duplicate from (
    select
        raw_data:"Customer ID"::string as customer_id,
        raw_data:"Customer Name"::string as customer_name,
        raw_data:"Customer Segment"::string as customer_segment,
        raw_data:"Country"::string as country,
        raw_data:"City"::string as city,
        raw_data:"State"::string as state,
        raw_data:"Region"::string as region,
        raw_data:"Market"::string as market,
        row_number() over (
            partition by raw_data:"Customer ID"::string
            order by load_time desc
        ) as duplicate_rank,
        load_time
    from {{ source('bronze','raw_customers') }}
    where raw_data:"Customer ID" is not null
)