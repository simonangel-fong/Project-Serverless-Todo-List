import json
import boto3
import pandas as pd
from io import StringIO
from datetime import datetime


def lambda_handler(event, context):
    # Read CSV file from S3
    bucket = 'aws-api.arguswatcher.net'
    key = 'user_trip_duration.csv'

    s3_client = boto3.client('s3')
    csv_file = s3_client.get_object(Bucket=bucket, Key=key)
    data = csv_file['Body'].read().decode('utf-8')

    # Process data into pandas DataFrame
    df = pd.read_csv(StringIO(data))

    # Prepare JSON response
    response = {
        "title": "User-based Trip & Duration Data",
        "creator": "Wenhao Fang",
        "deployed on": "Proxmox VM",
        "datetime": datetime.now().strftime("%Y-%m-%d %H:%M"),
        "status": "success",
        "item_count": len(df),
        "data": df.to_dict(orient='records')
    }

    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }


if __name__ == "__main__":
    print(lambda_handler(None, None))
