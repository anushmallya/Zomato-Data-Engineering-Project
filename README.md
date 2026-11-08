# Zomato_Data_Engineering_Project

Building an end-to-end data engineering pipeline using Zomato datasets to perform data ingestion, transformation, incremental processing, and dimensional modelling, producing structured data for analytics.

## 🚀 Project Overview

The project implements an end-to-end data pipeline using **Databricks, dbt, Python, Apache Airflow, and Docker** to process Zomato data across multiple stages.
The pipeline processes seven CSV datasets: food, menu, order items, orders, restaurant, reviews, and users.
The source CSV files are initially stored locally and uploaded to a **Databricks Volume** using Python and the Databricks SDK. dbt is then used to read the sorce files and create corresponding source tables in Databricks.
The project follows the **Medallion Architecture**, separating data processing into Bronze, Silver, and Gold layers.
The Bronze layer maintains the source data with incremental processing. The Silver layer applies data cleaning, standardization, type casting, and other SQL transformations. Data quality tests are implemented to validate the transformed datasets.
The Gold layer uses **Star Schema modelling** to create fact and dimension tables for analytical use. dbt snapshots implement **Slowly Changing Dimension Type 2 (SCD Type 2)** to maintain historical versions of customer, food, and restaurant dimensions.
The complete workflow is automated using **Apache Airflow and Docker**, with individual DAGs for each processing stage and a master DAG to orchestrate the pipeline from ingestion to Gold.

## 🏗️ Architecture

The workflow follows this sequence:

Local CSV Files → Databricks Volume → Source Tables → Bronze → Silver → Gold

Apache Airflow orchestrates the individual processing stages, while Docker provides the environment for running the Airflow services.

## 🛠️ Resources & Technologies Used

* **Databricks**
* **Databricks Unity Catalog and Volumes**
* **Databricks SDK**
* **dbt Core**
* **dbt-databricks**
* **Apache Airflow**
* **Docker and Docker Compose**
* **Python**
* **SQL**
* **PySpark / Spark Fundamentals**
* **Parquet and CSV**
* **Medallion Architecture**
* **Star Schema Modelling**
* **Git and GitHub**

## 📥 Data Ingestion

The project uses seven locally stored CSV files as source datasets.

A Python script using the Databricks SDK is used to upload the files into a Databricks Volume.

### Ingestion Workflow

* Stores the seven CSV files in a local project directory.
* Creates a Databricks Catalog named `zomato_dep`.
* Creates a schema named `source` and a Volume named `source_data`.
* Uses the Databricks SDK and `WorkspaceClient` to connect to the workspace.
* Uses Python's `pathlib` to identify CSV files in the local directory.
* Uploads the files to the Databricks Volume using `upload_from()`.

The uploaded files are available at:

`/Volumes/zomato_dep/source/source_data`

This approach provides a centralized location for the source datasets before dbt processing.

## 🥉 Source and Bronze Layers

The source layer contains seven dbt models corresponding to the uploaded CSV files.

The models use Databricks SQL `read_files()` to read the CSV files from the Databricks Volume.

### Source Tables

* `food`
* `menu`
* `order_items`
* `orders`
* `restaurant`
* `reviews`
* `users`

### Source Processing

* Reads CSV files using Databricks SQL `read_files()`.
* Uses CSV options for headers, multiline records, and column type inference.
* Implements incremental materialization with the merge strategy.
* Uses business keys or composite keys to identify records.
* Applies SHA-256 row hashing in five models to identify changed records.
* Uses timestamp-based processing for the orders and reviews datasets.
* Adds `source_ingest_time` to the models using row hashing.

The source models serve as the input for the Bronze layer.

### Bronze Layer

The Bronze layer stores the source datasets as tables in the Databricks Bronze schema.

The models use dbt incremental materialization with the merge strategy and configured unique keys.

### Incremental Processing

* Uses `source()` references to access the source tables.
* Uses `is_incremental()` to apply incremental filters.
* Uses `source_ingest_time` for models that track changes using row hashes.
* Uses source timestamps such as `order_timestamp` and `review_date` for the respective models.
* Excludes the intermediate `row_hash` column from the applicable Bronze output tables.

All seven Bronze models were executed successfully, creating the corresponding tables in the Bronze schema.

## 🥈 Silver Layer

The Silver layer is developed using dbt and Databricks SQL.

It applies data cleaning, standardization, type conversions, and transformations to prepare the datasets for analytical modelling.

### Transformations and Processing

* Renames columns to maintain consistent naming conventions.
* Handles missing values in selected columns using default values such as `Unknown`.
* Removes unnecessary whitespace from text fields.
* Converts columns into appropriate data types.
* Standardizes email values to lowercase.
* Cleans menu prices by removing non-numeric characters and converting them into decimal values.
* Filters invalid menu records with missing restaurant IDs or non-positive prices.
* Joins order and review datasets with restaurant information to include city attributes.
* Derives an `is_delivered` field from order status.
* Uses incremental materialization and merge operations to process records.

### Data Quality Testing

dbt tests are implemented to validate the Silver models.

The tests include:

* **Uniqueness:** Checks for duplicate records using configured business keys.
* **Not Null:** Validates important identifiers and required columns.
* **Conditional Not Null:** Validates menu prices for records where price is greater than zero.

The tests were executed successfully for the configured Silver models.

The Silver layer provides cleaned and standardized datasets for Gold-layer processing.

## 🥇 Gold Layer

The Gold layer contains business-ready fact and dimension tables designed using **Star Schema modelling**.

The dimensional models are developed using dbt, with snapshots used to preserve historical changes in selected dimensions.

### Ephemeral Models

Three dbt ephemeral models are created as inputs for the dimension snapshots:

* `customers`
* `food`
* `restaurant`

The customer model includes a customer generation classification based on age.

The restaurant model uses distinct records, while the food model selects the required attributes from the Silver layer.

### Dimension Tables

* `dim_customers`
* `dim_food`
* `dim_restaurant`
* `dim_date`

The customer, food, and restaurant dimensions are generated using dbt snapshot data. The date dimension is generated using a date sequence and includes attributes such as year, month, month name, day name, and weekend indicator.

### Fact Tables

* `fact_order_items`
* Order-level fact model

The order-item fact model combines Silver order-item and order data to include relevant order, restaurant, food, date, and measure attributes.

The order-level fact model uses the Silver orders dataset and excludes the currency column.

### Slowly Changing Dimension Type 2 (SCD Type 2)

dbt snapshots are implemented using the timestamp strategy to maintain historical versions of the following dimensions:

* Customers
* Food
* Restaurant

The snapshot configuration uses the corresponding update timestamp columns to detect changes.

The dimension models use snapshot metadata to derive an `active_status` field:

* **Active:** Current dimension record where `dbt_valid_to` is NULL.
* **Inactive:** Historical dimension record where `dbt_valid_to` is populated.

This approach retains previous dimension versions instead of simply overwriting changed records.

## 🔄 Incremental Data Processing

Incremental processing is implemented across the source, Bronze, and Silver layers, with historical tracking in the Gold dimensions.

### Source Processing

The source models use SHA-256 row hashes for five datasets to identify changed records. Orders and reviews use their respective source timestamps.

### Source to Bronze

The Bronze models use dbt incremental materialization with merge strategies and configured unique keys.

Incremental filters use `is_incremental()` and the relevant timestamp columns to select records for processing.

### Bronze to Silver

The Silver models use incremental merge processing with unique keys.

The incremental filters compare the relevant source timestamps with the latest processed timestamps in the corresponding Silver tables.

### Silver to Gold

The Gold fact models use incremental merge processing to maintain the fact tables.

dbt snapshots use timestamp-based change detection to preserve historical dimension versions.

This approach demonstrates incremental processing and historical tracking across the different stages of the pipeline.

## ⚙️ Workflow Orchestration

Apache Airflow is used to orchestrate the complete data pipeline, with Docker and Docker Compose used to run the Airflow environment.

### Individual DAGs

Separate DAGs are created for the following processing stages:

* `data_to_databricks` – Uploads the local CSV files to the Databricks Volume.
* `source_table` – Executes the dbt source models.
* `bronze_table` – Executes the Bronze models.
* `silver_table` – Builds the Silver models and runs the configured tests.
* `gold_table` – Executes dbt snapshots followed by Gold models.

### Master DAG

A master DAG named `zomato_pipeline` is created using `TriggerDagRunOperator`.

The master DAG triggers the individual DAGs in the following sequence:

1. Data ingestion
2. Source table creation
3. Bronze processing
4. Silver processing
5. Gold processing

Each triggered DAG uses `wait_for_completion=True` so the master workflow waits for the current stage to finish before proceeding to the next stage.

The complete master DAG was executed successfully using the Docker-based Airflow environment.

## 🎯 Project Objectives

The main objectives of this project are to demonstrate:

* End-to-end data engineering using Databricks and dbt.
* Python-based ingestion using the Databricks SDK.
* Databricks Catalog and Volume management.
* Source data processing using Databricks SQL.
* Bronze, Silver, and Gold Medallion Architecture.
* Incremental data processing using dbt.
* Change detection using SHA-256 row hashing.
* SQL-based data cleaning and transformation.
* Data quality testing using dbt.
* Historical data tracking using SCD Type 2 snapshots.
* Fact and dimension modelling using Star Schema.
* Workflow orchestration using Apache Airflow.
* Containerized workflow execution using Docker.

## 💡 Design Decisions

* **Databricks Volume:** Used as the centralized storage location for the seven source CSV files.
* **dbt:** Used to organize SQL transformations, incremental models, snapshots, and data quality tests.
* **Incremental Merge:** Used to process changes while maintaining records based on configured unique keys.
* **SHA-256 Row Hashing:** Used in selected source models to detect changes in records.
* **Timestamp-Based Snapshots:** Used to maintain historical versions of customer, food, and restaurant dimensions.
* **Star Schema:** Used to structure the Gold layer into fact and dimension tables.
* **Apache Airflow:** Used to orchestrate individual processing stages and the complete pipeline.
* **Docker:** Used to configure and run the Airflow environment.

## 🔗 Connect with Me
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue)](https://www.linkedin.com/in/anush-mallya-k/)
