import boto3
import requests
import os
import json
from datetime import datetime

def lambda_handler(event, context):
    # Load environment variables
    api_url = os.environ['API_URL']          # The API endpoint URL
    s3_bucket = os.environ['S3_BUCKET']     # The S3 bucket where backups will be stored

    try:
        # Step 1: Make a POST request to the API URL 
        print(f"Fetching blog posts from API: {api_url}")
        response = requests.post(api_url, json={})
        response.raise_for_status()  # Raise an error for bad HTTP status codes (e.g., 4xx/5xx)

        # Step 2: Process the API Response
        blog_posts = response.json()  # Expecting response to be JSON
        print(f"Retrieved {len(blog_posts)} blog posts.")

        # Step 3: Format the output as JSON
        backup_data = {
            "timestamp": datetime.utcnow().isoformat(),
            "blog_posts": blog_posts
        }

        # Step 4: Upload the data to S3 bucket
        s3 = boto3.client('s3')
        file_key = f"backups/blog_backup_{datetime.utcnow().strftime('%Y-%m-%d_%H-%M-%S')}.json"
        s3.put_object(
            Bucket=s3_bucket,
            Key=file_key,
            Body=json.dumps(backup_data),
            ContentType='application/json'
        )
        
        print(f"Successfully backed up blog posts to S3: {file_key}")

        return {
            "statusCode": 200,
            "body": f"Backup saved to {file_key} in bucket {s3_bucket}"
        }

    except requests.exceptions.RequestException as e:
        print(f"Error fetching blog posts from API: {e}")
        return {
            "statusCode": 500,
            "body": f"Error fetching blog posts: {str(e)}"
        }

    except boto3.exceptions.Boto3Error as e:
        print(f"Error uploading to S3: {e}")
        return {
            "statusCode": 500,
            "body": f"Error uploading to S3: {str(e)}"
        }