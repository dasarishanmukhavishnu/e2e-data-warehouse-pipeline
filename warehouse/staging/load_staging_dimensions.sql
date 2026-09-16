CREATE TABLE IF NOT EXISTS staging.sellers (
    seller_id VARCHAR(100) PRIMARY KEY,
    zip_code_prefix VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(2),
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    staged_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staging.categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    staged_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staging.products (
    product_id VARCHAR(100) PRIMARY KEY,
    category_id INT,
    name_length INT,
    description_length INT,
    photos_qty INT,
    weight_g INT,
    product_length_cm INT,
    height_cm INT,
    width_cm INT,
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    staged_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE staging.sellers, staging.categories, staging.products;

INSERT INTO staging.sellers (
    seller_id, zip_code_prefix, city, state,
    source_created_at, source_updated_at
)
SELECT DISTINCT ON (seller_id)
    TRIM(seller_id),
    NULLIF(TRIM(zip_code_prefix), ''),
    NULLIF(TRIM(city), ''),
    NULLIF(UPPER(TRIM(state)), ''),
    created_at,
    updated_at
FROM raw.sellers
WHERE seller_id IS NOT NULL
ORDER BY seller_id, extracted_at DESC;

INSERT INTO staging.categories (
    category_id, category_name,
    source_created_at, source_updated_at
)
SELECT DISTINCT ON (category_id)
    category_id,
    TRIM(category_name),
    created_at,
    updated_at
FROM raw.categories
WHERE category_id IS NOT NULL
ORDER BY category_id, extracted_at DESC;

INSERT INTO staging.products (
    product_id, category_id, name_length, description_length,
    photos_qty, weight_g, product_length_cm, height_cm, width_cm,
    source_created_at, source_updated_at
)
SELECT DISTINCT ON (product_id)
    TRIM(product_id),
    category_id,
    name_length,
    description_length,
    photos_qty,
    weight_g,
    product_length_cm,
    height_cm,
    width_cm,
    created_at,
    updated_at
FROM raw.products
WHERE product_id IS NOT NULL
ORDER BY product_id, extracted_at DESC;