CREATE TABLE IF NOT EXISTS staging.customers (
    customer_id VARCHAR(100) PRIMARY KEY,
    customer_unique_id VARCHAR(100),
    zip_code_prefix VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(2),
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    staged_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE staging.customers;

INSERT INTO staging.customers (
    customer_id,
    customer_unique_id,
    zip_code_prefix,
    city,
    state,
    source_created_at,
    source_updated_at
)

SELECT DISTINCT ON(customer_id)
    TRIM(customer_id),
    NULLIF(TRIM(customer_unique_id),''),
    NULLIF(TRIM(zip_code_prefix),''),
    NULLIF(TRIM(city),''),
    NULLIF(UPPER(TRIM(state)),''),
    created_at,
    updated_at
FROM raw.customers
WHERE customer_id IS NOT NULL
ORDER BY customer_id,extracted_at DESC
