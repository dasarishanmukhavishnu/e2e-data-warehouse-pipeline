import os
from pathlib import Path
import mysql.connector
import psycopg
from dotenv import load_dotenv

project_root = Path(__file__).resolve().parents[2]
load_dotenv(project_root / ".env")

TABLES = {
    "customers": [
        "customer_id",
        "customer_unique_id",
        "zip_code_prefix",
        "city",
        "state",
        "created_at",
        "updated_at",
    ],
    "sellers": [
        "seller_id",
        "zip_code_prefix",
        "city",
        "state",
        "created_at",
        "updated_at",
    ],
    "categories": [
        "category_id",
        "category_name",
        "created_at",
        "updated_at",
    ],
    "products": [
        "product_id",
        "category_id",
        "name_length",
        "description_length",
        "photos_qty",
        "weight_g",
        "product_length_cm",
        "height_cm",
        "width_cm",
        "created_at",
        "updated_at",
    ],
    "orders": [
        "order_id",
        "customer_id",
        "order_status",
        "purchase_timestamp",
        "approved_at",
        "delivered_carrier_date",
        "delivered_customer_date",
        "estimated_delivery_date",
        "created_at",
        "updated_at",
    ],
    "order_items": [
        "order_id",
        "order_item_id",
        "product_id",
        "seller_id",
        "shipping_limit_date",
        "price",
        "freight_value",
        "created_at",
        "updated_at",
    ],
    "payments": [
        "payment_id",
        "order_id",
        "payment_sequence",
        "payment_type",
        "installments",
        "payment_value",
        "created_at",
        "updated_at",
    ],
    "reviews": [
        "review_key",
        "review_id",
        "order_id",
        "review_score",
        "review_comment_title",
        "review_comment_message",
        "review_creation_date",
        "review_answer_timestamp",
        "created_at",
        "updated_at",
    ],
}

def get_mysql_connection():
    return mysql.connector.connect(
        host=os.getenv("MYSQL_HOST"),
        port=int(os.getenv("MYSQL_PORT","3306")),
        user=os.getenv("MYSQL_USER"),
        password=os.getenv("MYSQL_PASSWORD"),
        database=os.getenv("MYSQL_DATABASE"),
    )

def get_postgres_connection():
    return psycopg.connect(
        host=os.getenv("POSTGRES_HOST"),
        port=int(os.getenv("POSTGRES_PORT","5432")),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        dbname=os.getenv("POSTGRES_DATABASE"),
    )

def load_table(mysql_cursor,postgres_cursor,table_name,columns):
    column_list = ", ".join(columns)
    placeholders = ", ".join(["%s"] * len(columns))

    mysql_cursor.execute(
        f"SELECT {column_list} FROM {table_name};"
    )
    rows = mysql_cursor.fetchall()

    postgres_cursor.execute(f"TRUNCATE TABLE raw.{table_name};")
    postgres_cursor.executemany(f"""
        INSERT INTO raw.{table_name} ({column_list})
        VALUES({placeholders})
        """,
        rows
    )

    print(f"Loaded {len(rows)} records into raw.{table_name}.")
    

mysql_connection = get_mysql_connection()
postgres_connection = get_postgres_connection()

mysql_cursor = mysql_connection.cursor()
postgres_cursor = postgres_connection.cursor()

for table_name, columns in TABLES.items():
    load_table(mysql_cursor,postgres_cursor,table_name,columns)

postgres_connection.commit()

mysql_cursor.close()
postgres_cursor.close()
mysql_connection.close()
postgres_connection.close()