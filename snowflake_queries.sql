-- =====================================================
-- FILE: snowflake_queries.sql
-- PURPOSE: Snowflake ETL configuration and data loading
-- =====================================================


-- =========================================
-- CREATE DATABASE
-- =========================================

CREATE DATABASE IF NOT EXISTS etl_db;


-- =========================================
-- USE DATABASE
-- =========================================

USE DATABASE etl_db;


-- =========================================
-- USE PUBLIC SCHEMA
-- =========================================

USE SCHEMA PUBLIC;


-- =========================================
-- CREATE STORAGE INTEGRATION
-- =========================================

CREATE OR REPLACE STORAGE INTEGRATION s3_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'YOUR_AWS_ROLE_ARN'
STORAGE_ALLOWED_LOCATIONS = ('s3://etl-project-akash-2026/');


-- =========================================
-- GET SNOWFLAKE IAM DETAILS
-- =========================================

DESC INTEGRATION s3_int;


-- =========================================
-- CREATE FILE FORMAT
-- =========================================

CREATE OR REPLACE FILE FORMAT csv_format
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';


-- =========================================
-- CREATE EXTERNAL STAGE
-- =========================================

CREATE OR REPLACE STAGE customers_stage
URL='s3://etl-project-akash-2026/customers/'
STORAGE_INTEGRATION = s3_int
FILE_FORMAT = csv_format;


-- =========================================
-- CREATE TARGET TABLE
-- =========================================

CREATE OR REPLACE TABLE customers (
    customer_id INT,
    customer_name STRING,
    email STRING,
    city STRING
);


-- =========================================
-- LOAD DATA FROM S3 TO SNOWFLAKE
-- =========================================

COPY INTO customers
FROM @customers_stage;


-- =========================================
-- VERIFY LOADED DATA
-- =========================================

SELECT * FROM customers;


-- =========================================
-- CHECK FILES AVAILABLE IN STAGE
-- =========================================

LIST @customers_stage;