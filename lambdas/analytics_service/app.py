import json
import os
import time
import boto3
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

s3 = boto3.client("s3")
BUCKET = os.environ["ANALYTICS_BUCKET"]

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    timestamp = int(time.time())

    for record in event.get("Records", []):
        detail = record.get("detail", {})

        key = f"orders/{timestamp}-{detail.get('orderId', 'unknown')}.json"

        s3.put_object(
            Bucket=BUCKET,
            Key=key,
            Body=json.dumps(detail).encode("utf-8")
        )

        logger.info("Wrote analytics event: %s", key)

    return {"status": "analytics-stored"}