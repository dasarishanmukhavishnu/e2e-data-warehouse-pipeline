# End-to-End Data Warehouse & Analytics Pipeline

An end-to-end Data Engineering project built using the Olist Brazilian E-Commerce dataset, focusing on **OLTP design, layered data processing, dimensional modeling, analytical SQL, and BI**.

> The project was initially planned as a multi-source pipeline, but the current implementation focuses on database design and Data Warehouse architecture. API, JSON, Parquet and other dynamic sources are planned as future extensions.

## Architecture

Olist Data → Python → MySQL OLTP → Validation → PostgreSQL RAW → STAGING → Data Warehouse → Analytical SQL → Power BI

## Current Implementation

- Designed and implemented an **OLTP database** in MySQL
- Built a **Python-based data loading pipeline** using Pandas and SQLAlchemy
- Implemented PostgreSQL **RAW and STAGING layers**
- Added data validation and quality checks
- Designed a **Star Schema** with fact and dimension tables
- Applied **grain, surrogate keys, natural keys and degenerate dimensions**
- Implemented multiple fact tables for sales, payments and reviews
- Built analytical SQL for business KPIs, sales, products, customers, geography, payments, reviews and delivery
- Built an interactive **Power BI dashboard**

## Tech Stack

**Python | Pandas | SQLAlchemy | MySQL | PostgreSQL | SQL | Power BI | Git | GitHub**

## Data Warehouse Model

### Dimensions
- Customer
- Product
- Seller
- Date

### Facts
- Order Items
- Payments
- Reviews

The warehouse was designed around clearly defined **fact-table grain and business processes** rather than simply copying the OLTP tables.

## Future Improvements

The project will continue evolving toward a more production-oriented Data Engineering pipeline:

- Incremental Data Loading
- SCD Type 2
- Airflow orchestration
- Dynamic/API-based data ingestion
- Parquet-based data processing
- Docker containerization
- AWS integration
- Data Lake / S3 architecture

## Project Documentation

For the **complete development journey**, including architecture decisions, database design, transformations, grain decisions, validation, warehouse modeling, challenges and implementation details, see:

`documentation/Project_3_Complete_Professional_Journey_Documentation.docx`

## Project Status

**Core Data Warehouse + Analytics implementation completed.**

The project is now being evolved step-by-step toward:

**Incremental Loading → SCD Type 2 → Airflow → Dynamic Data → Parquet → Docker → AWS**

The goal is not only to build the pipeline, but to understand the engineering decisions behind each component.

## Author

**Shanmukha Vishnu Dasari**  
B.Tech Artificial Intelligence & Data Science  
Aspiring Data Engineer