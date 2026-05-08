# 🏗️ ETL Pipeline Architecture

## 📌 Overview

This project demonstrates an end-to-end cloud ETL pipeline using:

- 🐘 PostgreSQL RDS
- ⚡ AWS Lambda
- ☁️ Amazon S3
- ❄️ Snowflake
- 🔄 AWS Step Functions

The pipeline extracts customer data from PostgreSQL, transforms it into CSV format, uploads it to Amazon S3, and loads it into Snowflake automatically.

---

# 🔥 Architecture Flow

```text
                ┌──────────────────────┐
                │ AWS Step Functions   │
                │  Workflow Trigger    │
                └──────────┬───────────┘
                           │
                           ▼
                ┌──────────────────────┐
                │ AWS Lambda Function  │
                │   ETL Processing     │
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