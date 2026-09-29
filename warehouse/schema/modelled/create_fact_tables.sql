CREATE TABLE IF NOT EXISTS warehouse.fact_order_items (
    order_id VARCHAR(100) NOT NULL,
    order_item_id INT NOT NULL,

    customer_key INT NOT NULL,
    product_key INT NOT NULL,
    seller_key INT NOT NULL,

    purchase_date_key INT,
    approval_date_key INT,
    shipping_limit_date_key INT,
    carrier_delivery_date_key INT,
    customer_delivery_date_key INT,
    estimated_delivery_date_key INT,

    price NUMERIC(12,2),
    freight_value NUMERIC(12,2),

    PRIMARY KEY (order_id, order_item_id),

    FOREIGN KEY (customer_key)
        REFERENCES warehouse.dim_customer(customer_key),

    FOREIGN KEY (product_key)
        REFERENCES warehouse.dim_product(product_key),

    FOREIGN KEY (seller_key)
        REFERENCES warehouse.dim_seller(seller_key),

    FOREIGN KEY (purchase_date_key)
        REFERENCES warehouse.dim_date(date_key),

    FOREIGN KEY (approval_date_key)
        REFERENCES warehouse.dim_date(date_key),

    FOREIGN KEY (shipping_limit_date_key)
        REFERENCES warehouse.dim_date(date_key),

    FOREIGN KEY (carrier_delivery_date_key)
        REFERENCES warehouse.dim_date(date_key),

    FOREIGN KEY (customer_delivery_date_key)
        REFERENCES warehouse.dim_date(date_key),

    FOREIGN KEY (estimated_delivery_date_key)
        REFERENCES warehouse.dim_date(date_key)
);

INSERT INTO warehouse.fact_order_items (
    order_id,
    order_item_id,

    customer_key,
    product_key,
    seller_key,

    purchase_date_key,
    approval_date_key,
    shipping_limit_date_key,
    carrier_delivery_date_key,
    customer_delivery_date_key,
    estimated_delivery_date_key,

    price,
    freight_value
)
SELECT
    oi.order_id,
    oi.order_item_id,

    dc.customer_key,
    dp.product_key,
    ds.seller_key,

    dd_purchase.date_key,
    dd_approval.date_key,
    dd_shipping_limit.date_key,
    dd_carrier.date_key,
    dd_customer_delivery.date_key,
    dd_estimated.date_key,

    oi.price,
    oi.freight_value

FROM staging.order_items oi

JOIN staging.orders o
    ON oi.order_id = o.order_id

JOIN warehouse.dim_customer dc
    ON o.customer_id = dc.customer_id

JOIN warehouse.dim_product dp
    ON oi.product_id = dp.product_id

JOIN warehouse.dim_seller ds
    ON oi.seller_id = ds.seller_id

LEFT JOIN warehouse.dim_date dd_purchase
    ON o.purchase_timestamp::DATE = dd_purchase.full_date

LEFT JOIN warehouse.dim_date dd_approval
    ON o.approved_at::DATE = dd_approval.full_date

LEFT JOIN warehouse.dim_date dd_shipping_limit
    ON oi.shipping_limit_date::DATE = dd_shipping_limit.full_date

LEFT JOIN warehouse.dim_date dd_carrier
    ON o.delivered_carrier_date::DATE = dd_carrier.full_date

LEFT JOIN warehouse.dim_date dd_customer_delivery
    ON o.delivered_customer_date::DATE = dd_customer_delivery.full_date

LEFT JOIN warehouse.dim_date dd_estimated
    ON o.estimated_delivery_date::DATE = dd_estimated.full_date;

CREATE TABLE IF NOT EXISTS warehouse.fact_payments (
    order_id VARCHAR(100) NOT NULL,
    payment_sequence INT NOT NULL,

    customer_key INT NOT NULL,
    purchase_date_key INT,

    payment_type VARCHAR(50),
    installments INT,
    payment_value NUMERIC(12,2),

    PRIMARY KEY (order_id, payment_sequence),

    FOREIGN KEY (customer_key)
        REFERENCES warehouse.dim_customer(customer_key),

    FOREIGN KEY (purchase_date_key)
        REFERENCES warehouse.dim_date(date_key)
);

INSERT INTO warehouse.fact_payments (
    order_id,
    payment_sequence,
    customer_key,
    purchase_date_key,
    payment_type,
    installments,
    payment_value
)
SELECT
    p.order_id,
    p.payment_sequence,
    dc.customer_key,
    dd.date_key,
    p.payment_type,
    p.installments,
    p.payment_value

FROM staging.payments p

JOIN staging.orders o
    ON p.order_id = o.order_id

JOIN warehouse.dim_customer dc
    ON o.customer_id = dc.customer_id

LEFT JOIN warehouse.dim_date dd
    ON o.purchase_timestamp::DATE = dd.full_date;

CREATE TABLE warehouse.fact_reviews (
    review_id VARCHAR(100) NOT NULL,
    order_id VARCHAR(100) NOT NULL,

    customer_key INT NOT NULL,

    review_creation_date_key INT,
    review_answer_date_key INT,

    review_score INT,

    PRIMARY KEY (review_id, order_id),

    FOREIGN KEY (customer_key)
        REFERENCES warehouse.dim_customer(customer_key),

    FOREIGN KEY (review_creation_date_key)
        REFERENCES warehouse.dim_date(date_key),

    FOREIGN KEY (review_answer_date_key)
        REFERENCES warehouse.dim_date(date_key)
);
INSERT INTO warehouse.fact_reviews (
    review_id,
    order_id,
    customer_key,
    review_creation_date_key,
    review_answer_date_key,
    review_score
)
SELECT
    r.review_id,
    r.order_id,
    dc.customer_key,
    dd_creation.date_key,
    dd_answer.date_key,
    r.review_score

FROM staging.reviews r

JOIN staging.orders o
    ON r.order_id = o.order_id

JOIN warehouse.dim_customer dc
    ON o.customer_id = dc.customer_id

LEFT JOIN warehouse.dim_date dd_creation
    ON r.review_creation_date::DATE = dd_creation.full_date

LEFT JOIN warehouse.dim_date dd_answer
    ON r.review_answer_timestamp::DATE = dd_answer.full_date;