/*
========================================================
DELIVERY ANALYSIS
========================================================

Purpose:
Analyze delivery performance.

Sources:
warehouse.fact_order_items
warehouse.dim_date
========================================================
*/

/*
--------------------------------------------------------
1. On-Time vs Late Delivery
--------------------------------------------------------

Business Question:
How many orders arrived on time versus late?

Result Grain:
One row = one delivery status category.
*/

select
    case
        when delivery_date.full_date <= estimated_date.full_date
            then 'On Time'
        else 'Late'
    end as delivery_status,count(distinct f.order_id) as orders
from warehouse.fact_order_items f
join warehouse.dim_date delivery_date
    on f.customer_delivery_date_key = delivery_date.date_key
join warehouse.dim_date estimated_date
    on f.estimated_delivery_date_key = estimated_date.date_key
group by
    case
        when delivery_date.full_date <= estimated_date.full_date
            then 'On Time'
        else 'Late'
    end
order by orders desc;

/*
--------------------------------------------------------
2. Delivery Performance by Month
--------------------------------------------------------

Business Question:
Does delivery performance change over time?

Result Grain:
One row = one purchase month + delivery status.
*/

select
    d.year,
    d.month,
    d.month_name,
    case
        when delivery_date.full_date <= estimated_date.full_date
            then 'on time'
        else 'late'
    end as delivery_status,
    count(distinct f.order_id) as orders
from warehouse.fact_order_items f
join warehouse.dim_date d
    on f.purchase_date_key = d.date_key
join warehouse.dim_date delivery_date
    on f.customer_delivery_date_key = delivery_date.date_key
join warehouse.dim_date estimated_date
    on f.estimated_delivery_date_key = estimated_date.date_key
group by
    d.year,
    d.month,
    d.month_name,
    case
        when delivery_date.full_date <= estimated_date.full_date
            then 'on time'
        else 'late'
    end
order by
    d.year,
    d.month;
