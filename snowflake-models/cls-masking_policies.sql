create or replace masking policy customer_name_masked as (val string) returns string ->
case
    when current_role() in ('developer','ACCOUNTADMIN') then val
    else '********'
end;

-- masking revenue
create or replace masking policy gold.mask_revenue as (val float) returns float ->
case
    when current_role() in ('data_analyst_role','ACCOUNTADMIN') then val
    else null
end;

show masking policies;