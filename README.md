# 🚀 End-to-End AWS ETL Pipeline Project

## 📌 Project Overview

This project demonstrates a complete cloud-based ETL (Extract, Transform, Load) pipeline using:

* 🐘 PostgreSQL RDS
* ⚡ AWS Lambda
* ☁️ Amazon S3
* ❄️ Snowflake
* 🔄 AWS Step Functions

The pipeline extracts data from PostgreSQL, transforms it into CSV format, uploads it to S3, and loads it into Snowflake automatically.

---

# 🏗️ Architecture Diagram

```text
                ┌──────────────────────┐
                │ AWS Step Functions   │
                │ (Workflow Trigger)   │
                └──────────┬───────────┘
                           │
                           ▼
                ┌──────────────────────┐
                │ AWS Lambda Function  │
                │  (ETL Processing)    │
                └──────────┬───────────┘
                           │
             ┌─────────────┴─────────────┐
             ▼                           ▼
   ┌──────────────────┐       ┌──────────────────┐
   │ PostgreSQL RDS   │       │ Amazon S3 Bucket │
   │ Source Database  │       │ Staging Layer    │
   └──────────────────┘       └────────┬─────────┘
                                        │
                                        ▼
                              ┌──────────────────┐
                              │ Snowflake DW     │
                              │ Data Warehouse   │
                              └──────────────────┘
```

---

# 🔥 Complete ETL Flow

## Step 1 — Step Functions starts workflow

AWS Step Functions triggers the Lambda function.

⬇️

## Step 2 — Lambda connects to PostgreSQL RDS

Lambda extracts customer data from PostgreSQL database.

⬇️

## Step 3 — Transformation

Data is transformed into CSV format.

⬇️

## Step 4 — Upload CSV to S3

CSV file is uploaded into Amazon S3 bucket.

⬇️

## Step 5 — Snowflake loads data

Snowflake reads the CSV from S3 and loads it into Snowflake tables.

---

# 📁 Recommended GitHub Project Structure

````text
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
│   ├── snowflake-copy-into.png
│   ├── snowflake-select-output.png
│   ├── step-functions-workflow.png
│   └── step-functions-success.png
│
├── architecture/
│   └── architecture-diagram.png
│
└── docs/
    ├── setup-guide.md
    └── aws-services-used.md
```text
etl-project/
│
├── lambda_function.py
├── requirements.txt
├── README.md
├── architecture.png
├── snowflake_queries.sql
└── screenshots/
````

---

# ⚙️ AWS Services Used

| Service        | Purpose                |
| -------------- | ---------------------- |
| PostgreSQL RDS | Source database        |
| AWS Lambda     | ETL processing         |
| Amazon S3      | Staging/data lake      |
| Snowflake      | Data warehouse         |
| Step Functions | Workflow orchestration |
| IAM            | Permissions management |
| CloudWatch     | Logging                |

---

# 🐘 Step 1 — Create PostgreSQL RDS Database

## RDS Configuration

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

⚠️ Note: This was temporary for testing.

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
(3, 'Aman', 'aman@gmail.com', 'Mumbai');
```

---

# ☁️ Step 2 — Create S3 Bucket

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

# ⚡ Step 3 — Create Lambda Function

## Lambda Configuration

| Setting       | Value                 |
| ------------- | --------------------- |
| Runtime       | Python 3.9            |
| Function Name | postgres-etl-function |

---

# 🔑 IAM Role Permissions

Attached Policies:

* AWSLambdaBasicExecutionRole
* AWSLambdaVPCAccessExecutionRole
* Custom S3 Policy

---

# 📦 Install pg8000 Dependency

Used CloudShell to install pg8000 package.

Commands used:

```bash
mkdir pg8000-package
cd pg8000-package
pip install pg8000 -t .
zip -r postgres-etl-pg8000.zip .
```

Uploaded ZIP into Lambda.

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
(3, 'Aman', 'aman@gmail.com', 'Mumbai');
```

---

# 📄 snowflake_queries.sql

Create file:

```text
sql/snowflake_queries.sql
```

Content:

```sql
CREATE DATABASE IF NOT EXISTS etl_db;

USE DATABASE etl_db;

USE SCHEMA PUBLIC;

CREATE OR REPLACE STORAGE INTEGRATION s3_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::YOUR_ACCOUNT_ID:role/LambdaETLRole'
STORAGE_ALLOWED_LOCATIONS = ('s3://etl-project-akash-2026/');

DESC INTEGRATION s3_int;

CREATE OR REPLACE FILE FORMAT csv_format
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

CREATE OR REPLACE STAGE customers_stage
URL='s3://etl-project-akash-2026/customers/'
STORAGE_INTEGRATION = s3_int
FILE_FORMAT = csv_format;

CREATE OR REPLACE TABLE customers (
    customer_id INT,
    customer_name STRING,
    email STRING,
    city STRING
);

COPY INTO customers
FROM @customers_stage;
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

    # PostgreSQL connection
    conn = pg8000.connect(
        host="YOUR_RDS_ENDPOINT",
        database="postgres",
        user="postgres",
        password="YOUR_PASSWORD",
        port=5432
    )

    cursor = conn.cursor()

    # Extract data
    cursor.execute("SELECT * FROM customers")

    rows = cursor.fetchall()

    # CSV path
    csv_file = "/tmp/customers.csv"

    # Transform + write CSV
    with open(csv_file, mode='w', newline='') as file:

        writer = csv.writer(file)

        writer.writerow([
            "customer_id",
            "customer_name",
            "email",
            "city"
        ])

        writer.writerows(rows)

    # Upload to S3
    s3 = boto3.client('s3')

    s3.upload_file(
        csv_file,
        "etl-project-akash-2026",
        "customers/customers.csv"
    )

    conn.close()

    return {
        'statusCode': 200,
        'body': json.dumps("CSV uploaded to S3 successfully!")
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

# ❄️ Step 4 — Configure Snowflake

## Create Database

```sql
CREATE DATABASE IF NOT EXISTS etl_db;

USE DATABASE etl_db;

USE SCHEMA PUBLIC;
```

---

# 🔗 Create Storage Integration

```sql
CREATE OR REPLACE STORAGE INTEGRATION s3_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::YOUR_ACCOUNT_ID:role/LambdaETLRole'
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

# 📥 Load Data into Snowflake

```sql
COPY INTO customers
FROM @customers_stage;
```

---

# ✅ Verify Data

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

* Drag “AWS Lambda Invoke”
* Select Lambda Function:

```text
postgres-etl-function
```

* Create State Machine
* Execute Workflow

---

# 🎯 Final Pipeline Flow

```text
Step Functions
      ↓
Lambda Function
      ↓
PostgreSQL RDS
      ↓
CSV Transformation
      ↓
Amazon S3
      ↓
Snowflake
```

---

# 📸 Recommended Screenshots for GitHub

Take screenshots of these pages and save them with these names:

| Screenshot                   | Suggested File Name         |
| ---------------------------- | --------------------------- |
| RDS PostgreSQL database page | rds-database.png            |
| PostgreSQL customers table   | customers-table.png         |
| Lambda function overview     | lambda-function.png         |
| Lambda successful execution  | lambda-success.png          |
| S3 bucket with CSV file      | s3-bucket.png               |
| Snowflake stage creation     | snowflake-stage.png         |
| COPY INTO query success      | snowflake-copy-into.png     |
| Snowflake SELECT output      | snowflake-select-output.png |
| Step Functions workflow      | step-functions-workflow.png |
| Step Functions success state | step-functions-success.png  |

Store them inside:

```text
screenshots/
```

---

# 🏆 Key Learnings

✅ Cloud ETL Architecture

✅ PostgreSQL Integration

✅ AWS Lambda Serverless ETL

✅ Amazon S3 Staging Layer

✅ Snowflake Data Warehouse Integration

✅ IAM Policies & Security

✅ AWS Step Functions Orchestration

---

# 🚀 Future Improvements

* EventBridge scheduling
* Incremental loading
* CloudWatch monitoring
* Error handling & retries
* Data validation
* CI/CD deployment

---

# 🧠 Resume Description

```text
Built an end-to-end cloud ETL pipeline using PostgreSQL RDS, AWS Lambda, Amazon S3, Snowflake, and AWS Step Functions. Implemented automated extraction, transformation, and loading of customer data into Snowflake using serverless architecture and cloud orchestration.
```

---

# ⭐ GitHub Repository Name Suggestions

* aws-etl-pipeline-project
* postgresql-to-snowflake-etl
* serverless-etl-pipeline
* aws-snowflake-etl-project
* end-to-end-data-engineering-project

---

# 📌 Technologies Used

![AWS](https://img.shields.io/badge/AWS-Cloud-orange)
![Lambda](https://img.shields.io/badge/AWS-Lambda-yellow)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-blue)
![Snowflake](https://img.shields.io/badge/Snowflake-DataWarehouse-cyan)
![Python](https://img.shields.io/badge/Python-ETL-green)
![S3](https://img.shields.io/badge/Amazon-S3-red)

---

# 🙌 Author

## Akash Soni

Cloud & Data Engineering Project

🚀 End-to-End AWS ETL Pipeline
