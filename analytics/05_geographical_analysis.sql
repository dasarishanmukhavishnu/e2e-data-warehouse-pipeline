/*
========================================================
GEOGRAPHICAL ANALYSIS
========================================================

Purpose:
Analyze sales and customer activity by state.

Sources:
warehouse.fact_order_items
warehouse.dim_customer
========================================================
*/

/*
--------------------------------------------------------
1. Revenue by State
--------------------------------------------------------

Business Question:
Which states generate the most revenue?

Result Grain:
One row = one customer state.
*/

select
    dc.state,sum(f.price) as revenue,count(distinct f.order_id) as orders,
    count(distinct dc.customer_id) as customers, 
    round(
        sum(f.price) / 
        nullif(count(distinct f.order_id), 0), 
        2
    ) as average_order_value
from warehouse.fact_order_items f
join warehouse.dim_customer dc
    on f.customer_key = dc.customer_key
group by
    dc.state
order by
    revenue desc;

/*
--------------------------------------------------------
2. Orders by State
--------------------------------------------------------

Business Question:
Where are the highest number of orders coming from?

Result Grain:
One row = one customer state.
*/

select 
    dc.state,count(distinct f.order_id) as orders
from warehouse.fact_order_items f
join warehouse.dim_customer dc
    on dc.customer_key = f.customer_key
group by dc.state
order by orders desc;
