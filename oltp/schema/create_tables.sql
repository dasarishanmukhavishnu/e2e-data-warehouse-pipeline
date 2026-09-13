CREATE TABLE customers (
    customer_id VARCHAR(100) PRIMARY KEY,
    customer_unique_id VARCHAR(100),
    zip_code_prefix VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

create table orders (
    order_id varchar(100) primary key,
    customer_id varchar(100),
    order_status varchar(50),
    purchase_timestamp DATETIME,
    approved_at DATETIME,
    delivered_carrier_date DATETIME,
    delivered_customer_date DATETIME,
    estimated_delivery_date DATETIME,
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp on update current_timestamp,

    foreign key(customer_id) references customers(customer_id)
);

CREATE TABLE sellers (
    seller_id VARCHAR(100) PRIMARY KEY,
    zip_code_prefix VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_categories_name UNIQUE (category_name)
);

create table products (
    product_id varchar(100) primary key,
    category_id int,
    name_length int,
    description_length int,
    photos_qty int,
    weight_g int,
    product_length_cm int,
    height_cm int,
    width_cm int,
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp on update current_timestamp,
    foreign key(category_id) references categories(category_id)
);

create table order_items (
    order_id varchar(100),
    order_item_id int,
    product_id varchar(100),
    seller_id varchar(100),
    shipping_limit_date DATETIME,
    price decimal(10,2),
    freight_value decimal(10,2),
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp on update current_timestamp,

    primary key(order_id,order_item_id),
    foreign key(order_id) references orders(order_id),
    foreign key (product_id) references products(product_id),
    foreign key(seller_id) references sellers(seller_id)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(100),
    payment_sequence INT NOT NULL,
    payment_type VARCHAR(30),
    installments INT,
    payment_value DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT uq_payments_order_sequence
        UNIQUE (order_id, payment_sequence)
);

CREATE TABLE reviews (
    review_key INT AUTO_INCREMENT PRIMARY KEY,
    review_id VARCHAR(100) NOT NULL,
    order_id VARCHAR(100) NOT NULL,
    review_score TINYINT UNSIGNED NOT NULL,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uq_reviews_source UNIQUE (review_id, order_id),
    CONSTRAINT fk_reviews_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
);