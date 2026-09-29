TRUNCATE TABLE
    warehouse.fact_reviews,
    warehouse.fact_payments,
    warehouse.fact_order_items,
    warehouse.dim_customer,
    warehouse.dim_product,
    warehouse.dim_seller,
    warehouse.dim_date
RESTART IDENTITY;