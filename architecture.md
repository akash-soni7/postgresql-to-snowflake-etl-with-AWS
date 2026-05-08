# 🏗️ Fully Automated ETL Pipeline Architecture

## 📌 Overview

This project demonstrates a **Fully Automated End-to-End Cloud ETL Pipeline** using:

- 🐘 PostgreSQL RDS
- ⚡ AWS Lambda
- ☁️ Amazon S3
- ❄️ Snowflake Snowpipe
- 🔄 AWS Step Functions

The pipeline automatically extracts customer data from PostgreSQL, transforms it into CSV format, uploads it to Amazon S3, and Snowpipe automatically loads the data into Snowflake in real-time.

---

# 🔥 Fully Automated Architecture Flow

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