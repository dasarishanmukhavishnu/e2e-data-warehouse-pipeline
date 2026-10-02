/*
========================================================
CUSTOMER ANALYSIS
========================================================

Purpose:
Understand customer purchasing behavior and value.

Sources:
warehouse.fact_order_items
warehouse.dim_customer
========================================================
*/
/*
--------------------------------------------------------
1. Top Customers by Revenue
--------------------------------------------------------

Business Question:
Which customers generate the most revenue?

Result Grain:
One row = one customer.
*/

select
    dc.customer_id,dc.city,dc.state,sum(f.price) as revenue,count(distinct f.order_id) as total_orders,
    round(sum(f.price)/nullif(count(distinct f.order_id),0), 2) as average_order_value
from warehouse.fact_order_items f
join warehouse.dim_customer dc
    on f.customer_key = dc.customer_key
group by dc.customer_id,dc.city,dc.state
order by revenue desc limit 20;

/*
--------------------------------------------------------
2. Customer Revenue Ranking
--------------------------------------------------------

Business Question:
How do customers rank based on revenue?

Result Grain:
One row = one customer.
*/

with customer_revenue as (
    select
        dc.customer_id,dc.city,dc.state,sum(f.price) as revenue,count(distinct f.order_id) as total_orders,
        round(sum(f.price)/nullif(count(distinct f.order_id),0), 2) as average_order_value
    from warehouse.fact_order_items f
    join warehouse.dim_customer dc
        on f.customer_key = dc.customer_key
    group by dc.customer_id,dc.city,dc.state
)
select 
    customer_id,state,revenue,dense_rank() over(order by revenue desc) as customer_rank
from customer_revenue
order by customer_rank;

/*
--------------------------------------------------------
3. One-Time vs Repeat Customers
--------------------------------------------------------

Business Question:
How many customers purchased once versus repeatedly?

Result Grain:
One row = one customer before final aggregation.
Final result grain = one customer type.
*/

with customer_orders as (
    select
        customer_key,
        count(distinct order_id) as order_count
    from warehouse.fact_order_items
    group by
        customer_key
)

select
    case
        when order_count = 1
            then 'One-Time Customer'
        else 'Repeat Customer'
    end as customer_type,
    count(*) AS customers
from customer_orders
group by
    case
        when order_count = 1
            then 'One-Time Customer'
        else 'Repeat Customer'
    end
order by customers desc;