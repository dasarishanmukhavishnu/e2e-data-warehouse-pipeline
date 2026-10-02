# End-to-End Data Warehouse & Analytics Pipeline

An end-to-end Data Engineering project built using the **Olist Brazilian E-Commerce dataset**, focusing on OLTP database design, layered data processing, dimensional modeling, analytical SQL, and BI.

## Project Scope

The project was initially planned as a multi-source pipeline. During implementation, I gave more focus to **database design and Data Warehouse architecture**.

The current implementation uses the Olist dataset as the primary source. API, JSON, Parquet, and other dynamic sources are planned as future extensions.

## Architecture

Olist Data
→ Python
→ MySQL OLTP
→ Data Validation
→ PostgreSQL RAW
→ PostgreSQL STAGING
→ Data Warehouse
→ Analytical SQL
→ Power BI

## Current Implementation

- Designed and implemented an OLTP database using **MySQL**
- Loaded and processed source data using **Python, Pandas, and MySQL Connector**
- Designed normalized relational tables with primary and foreign keys
- Implemented RAW and STAGING layers in PostgreSQL
- Performed data validation and quality checks
- Designed a dimensional Data Warehouse using a Star Schema
- Applied fact-table grain and surrogate key concepts
- Used natural and degenerate dimensions where appropriate
- Implemented:
  - `fact_order_items`
  - `fact_payments`
  - `fact_reviews`
- Implemented:
  - `dim_customer`
  - `dim_product`
  - `dim_seller`
  - `dim_date`
- Developed analytical SQL queries for business analysis
- Built an interactive **Power BI dashboard**

## Data Warehouse Model

### Dimensions

- Customer
- Product
- Seller
- Date

### Facts

- Order Items / Sales
- Payments
- Reviews

The warehouse was designed around **business processes and fact-table grain**, rather than simply copying the OLTP tables into the warehouse.

## Tech Stack

**Python | Pandas | MySQL Connector | MySQL | PostgreSQL | SQL | Power BI | Git | GitHub**

## Future Improvements

- Incremental Data Loading
- SCD Type 2
- Apache Airflow
- Dynamic/API ingestion
- Parquet-based processing
- Docker
- AWS
- Data Lake / S3
- Additional data sources

## Project Documentation

For the complete development journey, see:

`documentation/Project_3_Complete_Professional_Journey_Documentation.docx`

The documentation contains detailed information about:

- Architecture decisions
- OLTP database design
- Normalization
- RAW and STAGING layers
- Data transformations
- Fact and dimension design
- Grain decisions
- Surrogate keys
- Validation and data quality
- Analytical SQL
- Power BI implementation
- Challenges and design decisions

## Project Status

### Completed

- OLTP Database
- Data Loading
- RAW Layer
- STAGING Layer
- Data Validation
- Data Warehouse
- Dimensional Modeling
- Analytical SQL
- Power BI Dashboard

### Future Development

`Incremental Loading → SCD Type 2 → Airflow → Dynamic Data Sources → Parquet → Docker → AWS`

## Author

**Shanmukha Vishnu Dasari**

B.Tech Artificial Intelligence & Data Science  
Aspiring Data Engineer