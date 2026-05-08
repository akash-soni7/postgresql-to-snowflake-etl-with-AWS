# 🚀 Fully Automated PostgreSQL → Snowflake ETL Pipeline using AWS

<div align="center">

![AWS](https://img.shields.io/badge/AWS-Cloud-orange)
![Lambda](https://img.shields.io/badge/AWS-Lambda-yellow)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-blue)
![Snowflake](https://img.shields.io/badge/Snowflake-DataWarehouse-cyan)
![Python](https://img.shields.io/badge/Python-ETL-green)
![S3](https://img.shields.io/badge/Amazon-S3-red)
![Snowpipe](https://img.shields.io/badge/Snowflake-Snowpipe-blue)

</div>

---

# 📌 Project Overview

This project demonstrates a **Fully Automated End-to-End Cloud ETL (Extract, Transform, Load) Pipeline** using:

* 🐘 PostgreSQL RDS
* ⚡ AWS Lambda
* ☁️ Amazon S3
* ❄️ Snowflake Snowpipe
* 🔄 AWS Step Functions
* 🔐 AWS IAM
* 📊 CloudWatch

The pipeline automatically:

✅ Extracts data from PostgreSQL RDS
✅ Transforms data into CSV format
✅ Uploads CSV files into Amazon S3
✅ Snowpipe automatically detects new files
✅ Snowflake automatically loads data in real-time
✅ AWS Step Functions orchestrates the entire workflow

---

# 🏗️ Fully Automated Architecture Diagram

```text
                    🚀 AWS Step Functions
                              │
                              ▼
                    ⚡ AWS Lambda Function
                       (ETL Processing)
                              │
                              ▼
                    🐘 PostgreSQL RDS
                        Source Database
                              │
                              ▼
                    🔄 CSV Transformation
                              │
                              ▼
                    ☁️ Amazon S3 Bucket
                         Staging Layer
                              │
                              ▼
                    ❄️ Snowpipe Auto Ingest
                              │
                              ▼
                    🏔️ Snowflake Warehouse
```

---

# 🔥 Complete ETL Workflow

## 1️⃣ AWS Step Functions Trigger

AWS Step Functions starts the ETL workflow automatically.

⬇️

## 2️⃣ Lambda Extracts Data

AWS Lambda connects to PostgreSQL RDS and extracts customer data.

⬇️

## 3️⃣ CSV Transformation

Lambda converts PostgreSQL records into CSV format.

⬇️

## 4️⃣ Upload CSV to Amazon S3

CSV file is uploaded automatically into S3 staging bucket.

⬇️

## 5️⃣ Snowpipe Auto Detection

Snowpipe automatically detects new CSV files uploaded into S3.

⬇️

## 6️⃣ Automatic Snowflake Loading

Snowflake automatically ingests data into warehouse tables.

---

# 📁 Recommended GitHub Project Structure

```text
postgresql-to-snowflake-etl-with-AWS/
│
├── README.md
│
├── lambda/
│   ├── lambda_function.py
│   └── requirements.txt
│
├── sql/
│   ├── postgres_queries.sql
│   ├── snowflake_queries.sql
│   └── verification_queries.sql
│
├── screenshots/
│   ├── rds-database.png
│   ├── customers-table.png
│   ├── lambda-function.png
│   ├── lambda-success.png
│   ├── s3-bucket.png
│   ├── snowflake-stage.png
│   ├── snowpipe.png
│   ├── snowflake-output.png
│   ├── step-functions-workflow.png
│   └── step-functions-success.png
│
├── architecture/
│   └── architecture-diagram.png
│
└── docs/
    ├── setup-guide.md
    └── aws-services-used.md
```

---

# ⚙️ AWS Services Used

| 🚀 Service            | 📌 Purpose                |
| --------------------- | ------------------------- |
| 🐘 PostgreSQL RDS     | Source Database           |
| ⚡ AWS Lambda          | Serverless ETL Processing |
| ☁️ Amazon S3          | Data Staging Layer        |
| ❄️ Snowflake          | Cloud Data Warehouse      |
| ❄️ Snowpipe           | Real-Time Auto Ingestion  |
| 🔄 AWS Step Functions | Workflow Orchestration    |
| 🔐 IAM                | Permissions Management    |
| 📊 CloudWatch         | Monitoring & Logging      |

---

# 🐘 Step 1 — Create PostgreSQL RDS Database

## 📌 RDS Configuration

| Setting       | Value           |
| ------------- | --------------- |
| Engine        | PostgreSQL      |
| DB Name       | etl-postgres-db |
| Username      | postgres        |
| Port          | 5432            |
| Public Access | Yes             |

---

# 🔐 Configure Security Group

Go to:

```text
RDS → Connectivity & Security → Security Groups
```

Add inbound rule:

| Type       | Port | Source    |
| ---------- | ---- | --------- |
| PostgreSQL | 5432 | 0.0.0.0/0 |

⚠️ Note: This was temporarily used for testing purposes.

---

# 🧱 Create Customers Table

Run this SQL inside PostgreSQL:

```sql
CREATE TABLE customers (
    customer_id INT,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(100)
);
```

---

# ➕ Insert Sample Data

```sql
INSERT INTO customers VALUES
(1, 'Akash', 'akash@gmail.com', 'Bhopal'),
(2, 'Rahul', 'rahul@gmail.com', 'Delhi'),
(3, 'Aman', 'aman@gmail.com', 'Mumbai'),
(4, 'Priya', 'priya@gmail.com', 'Pune'),
(5, 'Rohit', 'rohit@gmail.com', 'Hyderabad');
```

---

# ☁️ Step 2 — Create Amazon S3 Bucket

Go to:

```text
Amazon S3 → Create Bucket
```

Bucket Name:

```text
etl-project-akash-2026
```

Folder Created:

```text
customers/
```

---

# ⚡ Step 3 — Create AWS Lambda Function

## Lambda Configuration

| Setting       | Value                 |
| ------------- | --------------------- |
| Runtime       | Python 3.9            |
| Function Name | postgres-etl-function |

---

# 🔑 IAM Role Permissions

Attach these policies:

✅ AWSLambdaBasicExecutionRole
✅ AWSLambdaVPCAccessExecutionRole
✅ AmazonS3FullAccess

---

# 📦 Install pg8000 Dependency Using CloudShell

Commands used:

```bash
mkdir full-etl-package
cd full-etl-package

pip install pg8000 -t .
pip install boto3 -t .
```

---

# 📄 requirements.txt

Create file:

```text
lambda/requirements.txt
```

Content:

```text
pg8000
boto3
```

---

# 📄 postgres_queries.sql

Create file:

```text
sql/postgres_queries.sql
```

Content:

```sql
CREATE TABLE customers (
    customer_id INT,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(100)
);

INSERT INTO customers VALUES
(1, 'Akash', 'akash@gmail.com', 'Bhopal'),
(2, 'Rahul', 'rahul@gmail.com', 'Delhi'),
(3, 'Aman', 'aman@gmail.com', 'Mumbai'),
(4, 'Priya', 'priya@gmail.com', 'Pune'),
(5, 'Rohit', 'rohit@gmail.com', 'Hyderabad');
```

---

# 📄 snowflake_queries.sql

Create file:

```text
sql/snowflake_queries.sql
```

Content:

```sql
-- =========================================
-- CREATE DATABASE
-- =========================================

CREATE DATABASE IF NOT EXISTS etl_db;

USE DATABASE etl_db;

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
-- GET IAM DETAILS
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
```

---

# 📄 verification_queries.sql

Create file:

```text
sql/verification_queries.sql
```

Content:

```sql
LIST @customers_stage;

SELECT * FROM customers;
```

---

# 🐍 Lambda ETL Code

## lambda_function.py

```python
import json
import pg8000
import csv
import boto3


def lambda_handler(event, context):

    # PostgreSQL Connection
    conn = pg8000.connect(
        host="YOUR_RDS_ENDPOINT",
        database="ecommerce_etl",
        user="postgres",
        password="YOUR_POSTGRES_PASSWORD",
        port=5432
    )

    cursor = conn.cursor()

    # Extract Data
    cursor.execute("SELECT * FROM customers")

    rows = cursor.fetchall()

    # CSV File Path
    csv_file = "/tmp/customers.csv"

    # Transform + Write CSV
    with open(csv_file, mode='w', newline='') as file:

        writer = csv.writer(file)

        writer.writerow([
            "customer_id",
            "customer_name",
            "email",
            "city"
        ])

        writer.writerows(rows)

    # Upload CSV To S3
    s3 = boto3.client('s3')

    s3.upload_file(
        csv_file,
        "etl-project-akash-2026",
        "customers/customers.csv"
    )

    cursor.close()
    conn.close()

    return {
        'statusCode': 200,
        'body': json.dumps(
            'CSV uploaded to S3 successfully!'
        )
    }
```

---

# 🧪 Test Lambda Function

Expected Output:

```json
{
  "statusCode": 200,
  "body": "CSV uploaded to S3 successfully!"
}
```

---

# ❄️ Step 4 — Configure Snowflake + Snowpipe

## 🔗 Create Storage Integration

```sql
CREATE OR REPLACE STORAGE INTEGRATION s3_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'YOUR_AWS_ROLE_ARN'
STORAGE_ALLOWED_LOCATIONS = ('s3://etl-project-akash-2026/');
```

---

# 🔍 Get Snowflake IAM Details

```sql
DESC INTEGRATION s3_int;
```

Copy:

* STORAGE_AWS_IAM_USER_ARN
* STORAGE_AWS_EXTERNAL_ID

---

# 🔐 Configure IAM Trust Policy

Go to:

```text
IAM → Roles → LambdaETLRole → Trust Relationships
```

Replace trust policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "YOUR_STORAGE_AWS_IAM_USER_ARN"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "YOUR_STORAGE_AWS_EXTERNAL_ID"
        }
      }
    }
  ]
}
```

---

# 🔓 Add S3 Access Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::etl-project-akash-2026",
        "arn:aws:s3:::etl-project-akash-2026/*"
      ]
    }
  ]
}
```

---

# 📄 Create File Format

```sql
CREATE OR REPLACE FILE FORMAT csv_format
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';
```

---

# 📦 Create Stage

```sql
CREATE OR REPLACE STAGE customers_stage
URL='s3://etl-project-akash-2026/customers/'
STORAGE_INTEGRATION = s3_int
FILE_FORMAT = csv_format;
```

---

# 🧱 Create Snowflake Table

```sql
CREATE OR REPLACE TABLE customers (
    customer_id INT,
    customer_name STRING,
    email STRING,
    city STRING
);
```

---

# 🚀 Create Snowpipe

```sql
CREATE OR REPLACE PIPE customers_pipe
AUTO_INGEST = TRUE
AS
COPY INTO customers
FROM @customers_stage
FILE_FORMAT = (FORMAT_NAME = csv_format);
```

---

# 🔔 Configure S3 Event Notification

Go to:

```text
Amazon S3 → Bucket → Properties → Event Notifications
```

Create event notification:

| Setting     | Value                    |
| ----------- | ------------------------ |
| Event Name  | snowpipe-trigger         |
| Event Type  | All object create events |
| Prefix      | customers/               |
| Destination | SQS Queue                |

Paste Snowpipe notification ARN from:

```sql
SHOW PIPES;
```

---

# ✅ Verify Loaded Data

```sql
SELECT * FROM customers;
```

---

# 🔄 Step 5 — AWS Step Functions

Go to:

```text
AWS Step Functions → Create State Machine
```

## Workflow

* Add “AWS Lambda Invoke”
* Select Lambda Function:

```text
postgres-etl-function
```

* Create State Machine
* Execute Workflow

---

# 🎯 Final Fully Automated Pipeline Flow

```text
🔄 AWS Step Functions
          ↓
⚡ AWS Lambda
          ↓
🐘 PostgreSQL RDS
          ↓
🔄 CSV Transformation
          ↓
☁️ Amazon S3
          ↓
❄️ Snowpipe Auto Detection
          ↓
🏔️ Snowflake Data Warehouse
```

---

# 📸 Recommended Screenshots for GitHub

Take screenshots of these pages and save them with these names:

| 📸 Screenshot              | 📂 Suggested File Name      |
| -------------------------- | --------------------------- |
| RDS PostgreSQL Database    | rds-database.png            |
| PostgreSQL Customers Table | customers-table.png         |
| Lambda Function Overview   | lambda-function.png         |
| Lambda Success Output      | lambda-success.png          |
| S3 Bucket with CSV File    | s3-bucket.png               |
| Snowflake Stage Creation   | snowflake-stage.png         |
| Snowpipe Creation          | snowpipe.png                |
| Snowflake Table Output     | snowflake-output.png        |
| Step Functions Workflow    | step-functions-workflow.png |
| Step Functions Success     | step-functions-success.png  |

Store them inside:

```text
screenshots/
```

---

# 🏆 Key Learnings

✅ Fully Automated ETL Pipeline
✅ Event-Driven Data Engineering
✅ PostgreSQL Integration
✅ AWS Lambda Serverless ETL
✅ Amazon S3 Staging Layer
✅ Snowflake Snowpipe Auto Ingestion
✅ AWS Step Functions Orchestration
✅ IAM Policies & Security
✅ Cloud Data Warehousing

---

# 🚀 Future Improvements

* ⏰ EventBridge Scheduling
* 📈 Incremental Loading
* 📊 CloudWatch Monitoring
* 🔁 Retry Mechanisms
* 🧪 Data Validation
* ⚙️ CI/CD Deployment
* 🐳 Dockerized Lambda Deployment

---

# 🧠 Resume Description

```text
Built a fully automated end-to-end cloud ETL pipeline using PostgreSQL RDS, AWS Lambda, Amazon S3, Snowflake Snowpipe, and AWS Step Functions. Implemented automated extraction, transformation, staging, and real-time ingestion into Snowflake using event-driven cloud architecture.
```

---

# ⭐ GitHub Repository Name Suggestions

* aws-etl-pipeline-project
* postgresql-to-snowflake-etl
* serverless-etl-pipeline
* aws-snowflake-etl-project
* fully-automated-etl-pipeline

---

# 📌 Technologies Used

* 🐍 Python
* ☁️ AWS
* ⚡ Lambda
* 🐘 PostgreSQL
* ☁️ Amazon S3
* ❄️ Snowflake
* ❄️ Snowpipe
* 🔄 AWS Step Functions
* 🔐 IAM

---

# 🙌 Author

## Akash Soni

Cloud & Data Engineering Project

🚀 Fully Automated AWS ETL Pipeline
