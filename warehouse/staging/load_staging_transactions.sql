CREATE TABLE IF NOT EXISTS staging.orders (
    order_id VARCHAR(100) PRIMARY KEY,
    customer_id VARCHAR(100),
    order_status VARCHAR(50),
    purchase_timestamp TIMESTAMP,
    approved_at TIMESTAMP,
    delivered_carrier_date TIMESTAMP,
    delivered_customer_date TIMESTAMP,
    estimated_delivery_date TIMESTAMP,
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    staged_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staging.order_items (
    order_id VARCHAR(100),
    order_item_id INT,
    product_id VARCHAR(100),
    seller_id VARCHAR(100),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    staged_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE IF NOT EXISTS staging.payments (
    payment_id INT PRIMARY KEY,
    order_id VARCHAR(100),
    payment_sequence INT,
    payment_type VARCHAR(30),
    installments INT,
    payment_value NUMERIC(10,2),
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    staged_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staging.reviews (
    review_key INT PRIMARY KEY,
    review_id VARCHAR(100),
    order_id VARCHAR(100),
    review_score SMALLINT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    staged_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE staging.orders, staging.order_items, staging.payments, staging.reviews;

INSERT INTO staging.orders (
    order_id, customer_id, order_status,
    purchase_timestamp, approved_at, delivered_carrier_date,
    delivered_customer_date, estimated_delivery_date,
    source_created_at, source_updated_at
)
SELECT DISTINCT ON (order_id)
    TRIM(order_id),
    TRIM(customer_id),
    LOWER(NULLIF(TRIM(order_status), '')),
    purchase_timestamp,
    approved_at,
    delivered_carrier_date,
    delivered_customer_date,
    estimated_delivery_date,
    created_at,
    updated_at
FROM raw.orders
WHERE order_id IS NOT NULL
ORDER BY order_id, extracted_at DESC;

INSERT INTO staging.order_items (
    order_id, order_item_id, product_id, seller_id,
    shipping_limit_date, price, freight_value,
    source_created_at, source_updated_at
)
SELECT DISTINCT ON (order_id, order_item_id)
    TRIM(order_id),
    order_item_id,
    TRIM(product_id),
    TRIM(seller_id),
    shipping_limit_date,
    price,
    freight_value,
    created_at,
    updated_at
FROM raw.order_items
WHERE order_id IS NOT NULL
  AND order_item_id IS NOT NULL
ORDER BY order_id, order_item_id, extracted_at DESC;

INSERT INTO staging.payments (
    payment_id, order_id, payment_sequence, payment_type,
    installments, payment_value,
    source_created_at, source_updated_at
)
SELECT DISTINCT ON (payment_id)
    payment_id,
    TRIM(order_id),
    payment_sequence,
    LOWER(NULLIF(TRIM(payment_type), '')),
    installments,
    payment_value,
    created_at,
    updated_at
FROM raw.payments
WHERE payment_id IS NOT NULL
ORDER BY payment_id, extracted_at DESC;

INSERT INTO staging.reviews (
    review_key, review_id, order_id, review_score,
    review_comment_title, review_comment_message,
    review_creation_date, review_answer_timestamp,
    source_created_at, source_updated_at
)
SELECT DISTINCT ON (review_key)
    review_key,
    TRIM(review_id),
    TRIM(order_id),
    CASE
        WHEN review_score BETWEEN 1 AND 5 THEN review_score
        ELSE NULL
    END,
    NULLIF(TRIM(review_comment_title), ''),
    NULLIF(TRIM(review_comment_message), ''),
    review_creation_date,
    review_answer_timestamp,
    created_at,
    updated_at
FROM raw.reviews
WHERE review_key IS NOT NULL
ORDER BY review_key, extracted_at DESC;