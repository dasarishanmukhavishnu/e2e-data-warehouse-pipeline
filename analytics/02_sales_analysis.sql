/*
========================================================
SALES ANALYSIS
========================================================

Purpose:
Analyze revenue, orders and sales trends over time.

Main sources:
warehouse.fact_order_items
warehouse.dim_date
========================================================
*/

/*
--------------------------------------------------------
1. Monthly Sales Performance
--------------------------------------------------------

Business Question:
How does revenue change month by month?

Result Grain:
One row = one purchase month.
*/

select 
    d.year,
    d.month,
    d.month_name,
    sum(f.price) as revenue,
    sum(f.freight_value) as freight,
    count(distinct f.order_id) as total_orders,
    count(*) as items_sold
from warehouse.fact_order_items f
join warehouse.dim_date d
    on f.purchase_date_key = d.date_key
group by 
    d.year,d.month,d.month_name
order by
    d.year,d.month;

/*
--------------------------------------------------------
2. Month-over-Month Revenue Growth
--------------------------------------------------------

Business Question:
How much did revenue increase or decrease
compared with the previous month?

Result Grain:
One row = one purchase month.
*/

with monthly_revenue as (
    select 
        d.year,d.month,d.month_name,sum(f.price) as revenue
    from warehouse.fact_order_items f
    join warehouse.dim_date d
        on f.purchase_date_key = d.date_key
    group by 
        d.year,d.month,d.month_name
)

select
    year,month,month_name,revenue,
    lag(revenue) over(order by year,month) as previous_month_revenue,
    round(
        (revenue - lag(revenue) over (order by year,month)) 
        / nullif(lag(revenue) over (order by year,month),0) * 100
    ) as growth_percent
from monthly_revenue
order by year, month;

/*
--------------------------------------------------------
3. Cumulative Revenue
--------------------------------------------------------

Business Question:
How does total revenue accumulate over time?

Result Grain:
One row = one purchase month.
*/

with monthly_revenue as (
    select  
        d.year,d.month,d.month_name,sum(f.price) as revenue
    from warehouse.fact_order_items f
    join warehouse.dim_date d
        on f.purchase_date_key = d.date_key
    group by 
        d.year,d.month,d.month_name
)
select 
    year,month,month_name,revenue,
    sum(revenue) over(order by year,month) as cumulative_revenue
from monthly_revenue
order by year,month;