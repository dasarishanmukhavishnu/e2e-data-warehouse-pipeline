CREATE TABLE IF NOT EXISTS raw.customers (
    customer_id VARCHAR(100),
    customer_unique_id VARCHAR(100),
    zip_code_prefix VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(2),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    extracted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.sellers (
    seller_id VARCHAR(100),
    zip_code_prefix VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(2),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    extracted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.categories (
    category_id INT,
    category_name VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    extracted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.products (
    product_id VARCHAR(100),
    category_id INT,
    name_length INT,
    description_length INT,
    photos_qty INT,
    weight_g INT,
    product_length_cm INT,
    height_cm INT,
    width_cm INT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    extracted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.orders (
    order_id VARCHAR(100),
    customer_id VARCHAR(100),
    order_status VARCHAR(50),
    purchase_timestamp TIMESTAMP,
    approved_at TIMESTAMP,
    delivered_carrier_date TIMESTAMP,
    delivered_customer_date TIMESTAMP,
    estimated_delivery_date TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    extracted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.order_items (
    order_id VARCHAR(100),
    order_item_id INT,
    product_id VARCHAR(100),
    seller_id VARCHAR(100),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    extracted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.payments (
    payment_id INT,
    order_id VARCHAR(100),
    payment_sequence INT,
    payment_type VARCHAR(30),
    installments INT,
    payment_value NUMERIC(10,2),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    extracted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.reviews (
    review_key INT,
    review_id VARCHAR(100),
    order_id VARCHAR(100),
    review_score SMALLINT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    extracted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);