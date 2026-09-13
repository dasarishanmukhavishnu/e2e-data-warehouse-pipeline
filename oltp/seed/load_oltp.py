import csv
import os
from pathlib import Path
from decimal import Decimal
import mysql.connector
from dotenv import load_dotenv

project_root = Path(__file__).resolve().parents[2]
load_dotenv(project_root / ".env")

data_path = project_root / "data" / "raw"
def to_int(value):
    return int(value) if value else None
def to_decimal(value):
    return Decimal(value) if value else None 

def get_connection():
    return mysql.connector.connect(
        host=os.getenv("MYSQL_HOST"),
        port=int(os.getenv("MYSQL_PORT", "3306")),
        user=os.getenv("MYSQL_USER"),
        password=os.getenv("MYSQL_PASSWORD"),
        database=os.getenv("MYSQL_DATABASE"),
    )


def load_customers(cursor):
    csv_path = data_path / "olist_customers_dataset.csv"

    query = """
        INSERT INTO customers (
            customer_id, customer_unique_id, zip_code_prefix, city, state
        )
        VALUES (%s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            customer_unique_id = VALUES(customer_unique_id),
            zip_code_prefix = VALUES(zip_code_prefix),
            city = VALUES(city),
            state = VALUES(state);
    """

    with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)

        customers = [
            (
                row["customer_id"],
                row["customer_unique_id"],
                row["customer_zip_code_prefix"],
                row["customer_city"],
                row["customer_state"],
            )
            for row in reader
        ]

    cursor.executemany(query, customers)
    print(f"Processed {len(customers)} customer records.")


def load_sellers(cursor):
    csv_path = data_path / "olist_sellers_dataset.csv"

    query = """
        INSERT INTO sellers (
            seller_id, zip_code_prefix, city, state
        )
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            zip_code_prefix = VALUES(zip_code_prefix),
            city = VALUES(city),
            state = VALUES(state);
    """

    with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)

        sellers = [
            (
                row["seller_id"],
                row["seller_zip_code_prefix"],
                row["seller_city"],
                row["seller_state"],
            )
            for row in reader
        ]

    cursor.executemany(query, sellers)
    print(f"Processed {len(sellers)} seller records.")

def load_categories(cursor):
    csv_path = data_path / "product_category_name_translation.csv"

    query = """
        INSERT INTO categories (category_name)
        VALUES (%s)
        ON DUPLICATE KEY UPDATE
            category_name = VALUES(category_name);
    """

    with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)

        categories = list({
            (row["product_category_name_english"],)
            for row in reader
            if row["product_category_name_english"]
        })

    cursor.executemany(query, categories)
    print(f"Processed {len(categories)} category records.")

def load_products(cursor):
    translation_path = data_path / "product_category_name_translation.csv"
    products_path = data_path / "olist_products_dataset.csv"

    with translation_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)

        translations = {
            row["product_category_name"]: row["product_category_name_english"]
            for row in reader
            if row["product_category_name"]
            and row["product_category_name_english"]
        }

    cursor.execute("SELECT category_id, category_name FROM categories")
    category_ids = {
        category_name.lower(): category_id
        for category_id, category_name in cursor.fetchall()
        if category_name is not None
    }

    query = """
        INSERT INTO products (
            product_id,
            category_id,
            name_length,
            description_length,
            photos_qty,
            weight_g,
            product_length_cm,
            height_cm,
            width_cm
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            category_id = VALUES(category_id),
            name_length = VALUES(name_length),
            description_length = VALUES(description_length),
            photos_qty = VALUES(photos_qty),
            weight_g = VALUES(weight_g),
            product_length_cm = VALUES(product_length_cm),
            height_cm = VALUES(height_cm),
            width_cm = VALUES(width_cm);
    """

    with products_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)
        products = []

        for row in reader:
            english_category = translations.get(
                row["product_category_name"]
            )
            category_id = category_ids.get(english_category.lower()) if english_category else None

            products.append((
                row["product_id"],
                category_id,
                to_int(row["product_name_lenght"]),
                to_int(row["product_description_lenght"]),
                to_int(row["product_photos_qty"]),
                to_int(row["product_weight_g"]),
                to_int(row["product_length_cm"]),
                to_int(row["product_height_cm"]),
                to_int(row["product_width_cm"]),
            ))

    cursor.executemany(query, products)
    print(f"Processed {len(products)} product records.")    

def load_orders(cursor):
    csv_path = data_path / "olist_orders_dataset.csv"

    query = """
        INSERT INTO orders (
            order_id,
            customer_id,
            order_status,
            purchase_timestamp,
            approved_at,
            delivered_carrier_date,
            delivered_customer_date,
            estimated_delivery_date
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            customer_id = VALUES(customer_id),
            order_status = VALUES(order_status),
            purchase_timestamp = VALUES(purchase_timestamp),
            approved_at = VALUES(approved_at),
            delivered_carrier_date = VALUES(delivered_carrier_date),
            delivered_customer_date = VALUES(delivered_customer_date),
            estimated_delivery_date = VALUES(estimated_delivery_date);
    """

    with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)

        orders = [
            (
                row["order_id"],
                row["customer_id"],
                row["order_status"],
                row["order_purchase_timestamp"] or None,
                row["order_approved_at"] or None,
                row["order_delivered_carrier_date"] or None,
                row["order_delivered_customer_date"] or None,
                row["order_estimated_delivery_date"] or None,
            )
            for row in reader
        ]

    cursor.executemany(query, orders)
    print(f"Processed {len(orders)} order records.")

def load_order_items(cursor):
    csv_path = data_path / "olist_order_items_dataset.csv"

    query = """
        INSERT INTO order_items (
            order_id,
            order_item_id,
            product_id,
            seller_id,
            shipping_limit_date,
            price,
            freight_value
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            product_id = VALUES(product_id),
            seller_id = VALUES(seller_id),
            shipping_limit_date = VALUES(shipping_limit_date),
            price = VALUES(price),
            freight_value = VALUES(freight_value);
    """

    with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)

        order_items = [
            (
                row["order_id"],
                to_int(row["order_item_id"]),
                row["product_id"],
                row["seller_id"],
                row["shipping_limit_date"] or None,
                to_decimal(row["price"]),
                to_decimal(row["freight_value"]),
            )
            for row in reader
        ]

    cursor.executemany(query, order_items)
    print(f"Processed {len(order_items)} order-item records.")

def load_payments(cursor):
    csv_path = data_path / "olist_order_payments_dataset.csv"

    query = """
        INSERT INTO payments (
            order_id,
            payment_sequence,
            payment_type,
            installments,
            payment_value
        )
        VALUES (%s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            payment_type = VALUES(payment_type),
            installments = VALUES(installments),
            payment_value = VALUES(payment_value);
    """

    with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)

        payments = [
            (
                row["order_id"],
                to_int(row["payment_sequential"]),
                row["payment_type"],
                to_int(row["payment_installments"]),
                to_decimal(row["payment_value"]),
            )
            for row in reader
        ]

    cursor.executemany(query, payments)
    print(f"Processed {len(payments)} payment records.")

def load_reviews(cursor):
    csv_path = data_path / "olist_order_reviews_dataset.csv"

    query = """
        INSERT INTO reviews (
            review_id,
            order_id,
            review_score,
            review_comment_title,
            review_comment_message,
            review_creation_date,
            review_answer_timestamp
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            review_score = VALUES(review_score),
            review_comment_title = VALUES(review_comment_title),
            review_comment_message = VALUES(review_comment_message),
            review_creation_date = VALUES(review_creation_date),
            review_answer_timestamp = VALUES(review_answer_timestamp);
    """

    with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)

        reviews = [
            (
                row["review_id"],
                row["order_id"],
                to_int(row["review_score"]),
                row["review_comment_title"] or None,
                row["review_comment_message"] or None,
                row["review_creation_date"] or None,
                row["review_answer_timestamp"] or None,
            )
            for row in reader
        ]

    cursor.executemany(query, reviews)
    print(f"Processed {len(reviews)} review records.")

connection = get_connection()
cursor = connection.cursor()

load_customers(cursor)
load_sellers(cursor)
load_categories(cursor)
load_products(cursor)
load_orders(cursor)
load_order_items(cursor)
load_payments(cursor)
load_reviews(cursor)

connection.commit()
cursor.close()
connection.close()

print("OLTP loading completed successfully.")