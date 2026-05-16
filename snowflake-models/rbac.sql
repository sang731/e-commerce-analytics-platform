create role developer;
create role data_analyst_role;

show roles;

grant usage on warehouse data_load_wh to role developer;
grant usage on warehouse compute_wh to role developer;
grant usage on warehouse compute_wh to role data_analyst_role;

grant usage on database ecommerce_db to role developer;
grant usage on database ecommerce_db to role data_analyst_role;

grant usage on all schemas in database ecommerce_db to role developer;
grant usage on schema ecommerce_db.gold to role data_analyst_role;

grant select, insert, update, delete on all tables in schema ecommerce_db.silver to role developer;
grant select on all tables in schema ecommerce_db.gold to role data_analyst_role;

grant select on future tables in schema ecommerce_db.gold to role data_analyst_role;