/*
========================================================
BUSINESS KPIs
========================================================

Purpose:
Calculate high-level business metrics for the dashboard.

Source:
warehouse.fact_order_items
warehouse.fact_reviews
warehouse.dim_date

Each query should clearly state its result grain.
========================================================
*/

/*
--------------------------------------------------------
1. Overall Business Performance
--------------------------------------------------------

Business Question:
How is the overall e-commerce business performing?

Result Grain:
One row = entire business dataset.
*/

SELECT 
    SUM(price) AS total_revenue,
    SUM(freight_value) AS total_freight_value,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(*) AS total_items_sold,
    ROUND(
        SUM(price) / NULLIF(COUNT(DISTINCT order_id),0),2
    ) AS average_order_value
FROM warehouse.fact_order_items;

/*
--------------------------------------------------------
2. Average Review Score
--------------------------------------------------------

Business Question:
What is the overall customer satisfaction score?

Result Grain:
One row = entire review dataset.
*/

select 
    round(avg(review_score),2) as average_review_score
from warehouse.fact_reviews;