CREATE TABLE IF NOT EXISTS warehouse.dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    week_of_year INT NOT NULL,
    is_weekend  BOOLEAN ,

    CONSTRAINT uq_dim_date_full_date UNIQUE (full_date)
);

CREATE TABLE IF NOT EXISTS warehouse.dim_customer (
    customer_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id VARCHAR(100) NOT NULL,
    customer_unique_id VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(2),

    CONSTRAINT uq_dim_customer_customer_id UNIQUE (customer_id)
);

CREATE TABLE IF NOT EXISTS warehouse.dim_product (
    product_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id VARCHAR(100) NOT NULL,
    category_id INT,
    category_name VARCHAR(100),
    name_length INT,
    description_length INT,
    photos_qty INT,
    weight_g INT,
    product_length_cm INT,
    height_cm INT,
    width_cm INT,

    CONSTRAINT uq_dim_product_product_id UNIQUE (product_id)
);

CREATE TABLE IF NOT EXISTS warehouse.dim_seller (
    seller_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seller_id VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(2),

    CONSTRAINT uq_dim_seller_seller_id UNIQUE (seller_id)
);

INSERT INTO warehouse.dim_date (
    date_key,
    full_date,
    day,
    month,
    month_name,
    quarter,
    year,
    week_of_year,
    day_of_week,
    is_weekend
)
SELECT
    TO_CHAR(date_value, 'YYYYMMDD')::INT AS date_key,
    date_value::DATE AS full_date,
    EXTRACT(DAY FROM date_value)::INT AS day,
    EXTRACT(MONTH FROM date_value)::INT AS month,
    TO_CHAR(date_value, 'FMMonth') AS month_name,
    EXTRACT(QUARTER FROM date_value)::INT AS quarter,
    EXTRACT(YEAR FROM date_value)::INT AS year,
    EXTRACT(WEEK FROM date_value)::INT AS week_of_year,
    TO_CHAR(date_value, 'FMDay') AS day_of_week,
    EXTRACT(ISODOW FROM date_value) IN (6, 7) AS is_weekend
FROM generate_series(
    '2016-09-04'::DATE,
    '2020-04-09'::DATE,
    INTERVAL '1 day'
) AS date_value;

INSERT INTO warehouse.dim_customer (
    customer_id,
    customer_unique_id,
    city,
    state
)
SELECT 
    customer_id,
    customer_unique_id,
    city,
    state
FROM staging.customers; 

INSERT INTO warehouse.dim_product (
    product_id,
    category_id,
    category_name,
    name_length,
    description_length,
    photos_qty,
    weight_g,
    product_length_cm,
    height_cm,
    width_cm
)
SELECT
    p.product_id,
    p.category_id,
    c.category_name,
    p.name_length,
    p.description_length,
    p.photos_qty,
    p.weight_g,
    p.product_length_cm,
    p.height_cm,
    p.width_cm
FROM staging.products p
LEFT JOIN staging.categories c
    ON p.category_id = c.category_id;

INSERT INTO warehouse.dim_seller (
    seller_id,
    city,
    state
)
SELECT 
    seller_id,
    city,
    state
FROM staging.sellers;