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
        'body': json.dumps('Data extracted, transformed, and loaded to S3 successfully!')
    }