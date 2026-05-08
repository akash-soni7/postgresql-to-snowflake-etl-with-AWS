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
-- CREATE FILE FORMAT
-- =========================================

CREATE OR REPLACE FILE FORMAT csv_format
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';


-- =========================================
-- CREATE STAGE
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
-- CREATE SNOWPIPE
-- =========================================

CREATE OR REPLACE PIPE customers_pipe
AUTO_INGEST = TRUE
AS
COPY INTO customers
FROM @customers_stage
FILE_FORMAT = (FORMAT_NAME = csv_format);


-- =========================================
-- SHOW PIPE DETAILS
-- =========================================

SHOW PIPES;


-- =========================================
-- VERIFY DATA
-- =========================================

SELECT * FROM customers;