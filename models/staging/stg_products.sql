select *, case when duplicate_rank>1 then 'Y' else 'N' end as is_duplicate from (
    select
        raw_data:"Product ID"::string as product_id,
        raw_data:"Product Name"::string as product_name,
        raw_data:"Category"::string as category,
        raw_data:"Sub-Category"::string as sub_category,
        row_number() over (
            partition by raw_data:"Product ID"::string
            order by load_time desc
        ) as duplicate_rank,
        raw_data:"Market"::string as market,
        load_time
    from {{ source('bronze','raw_products') }}
    where raw_data:"Product ID" is not null
)