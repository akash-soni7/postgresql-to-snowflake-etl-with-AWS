import json
import pg8000
import csv
import boto3


def lambda_handler(event, context):

    # ======================================
    # PostgreSQL Connection
    # ======================================

    conn = pg8000.connect(
        host="etl-postgres-db.cte4o2kye847.ap-south-1.rds.amazonaws.com",
        database="ecommerce_etl",
        user="postgres",
        password="Akash123",
        port=5432
    )

    cursor = conn.cursor()

    # ======================================
    # Extract Data
    # ======================================

    cursor.execute("SELECT * FROM customers")

    rows = cursor.fetchall()

    # ======================================
    # Create CSV File
    # ======================================

    csv_file = "/tmp/customers.csv"

    with open(csv_file, mode='w', newline='') as file:

        writer = csv.writer(file)

        # CSV Header
        writer.writerow([
            "customer_id",
            "customer_name",
            "email",
            "city"
        ])

        # Write Rows
        writer.writerows(rows)

    # ======================================
    # Upload CSV To S3
    # ======================================

    s3 = boto3.client('s3')

    s3.upload_file(
        csv_file,
        "etl-project-akash-2026",
        "customers/customers.csv"
    )

    # ======================================
    # Close Connections
    # ======================================

    cursor.close()
    conn.close()

    return {
        'statusCode': 200,
        'body': json.dumps(
            'CSV uploaded to S3 successfully!'
        )
    }