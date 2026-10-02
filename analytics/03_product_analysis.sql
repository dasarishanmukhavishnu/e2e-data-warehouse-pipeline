/*
========================================================
PRODUCT ANALYSIS
========================================================

Purpose:
Understand which products and categories drive sales.

Sources:
warehouse.fact_order_items
warehouse.dim_product
========================================================
*/

/*
--------------------------------------------------------
1. Revenue by Product Category
--------------------------------------------------------

Business Question:
Which product categories generate the most revenue?

Result Grain:
One row = one product category.
*/

select 
    dp.category_name,sum(f.price) as revenue,sum(freight_value) as freight,
    count(distinct order_id) as total_orders,count(*) as items_sold
from warehouse.fact_order_items f
join warehouse.dim_product dp
    on f.product_key = dp.product_key
group by dp.category_name
order by revenue desc;

/*
--------------------------------------------------------
2. Top 10 Products by Revenue
--------------------------------------------------------

Business Question:
Which products generate the most revenue?

Result Grain:
One row = one product.
*/

select
    dp.product_id,dp.category_name,sum(f.price) as revenue,sum(f.freight_value) as freight,
    count(distinct order_id) as total_orders,count(*) as items_sold
from warehouse.fact_order_items f
join warehouse.dim_product dp
    on f.product_key = dp.product_key
group by dp.product_id,dp.category_name
order by revenue desc limit 10;


/*
--------------------------------------------------------
3. Top 3 Products Within Each Category
--------------------------------------------------------

Business Question:
Which products perform best within each category?

Result Grain:
One row = one product within one category.
*/

with product_revenue as (
    select 
        dp.product_id,dp.category_name,sum(f.price) as revenue
    from warehouse.fact_order_items f
    join warehouse.dim_product dp
        on f.product_key = dp.product_key
    group by dp.product_id,dp.category_name
),
ranked_product as (
    select
        product_id,category_name,revenue,
        dense_rank() over(partition by category_name order by revenue desc) as product_rank
    from product_revenue
)
select 
    product_id,category_name,revenue,product_rank
from ranked_product where product_rank <= 3
order by category_name,product_rank asc;