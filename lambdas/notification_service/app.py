import json
import os
import boto3
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

sns = boto3.client("sns")
TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    for record in event.get("Records", []):
        detail = record.get("detail", {})
        order_id = detail.get("orderId")

        message = f"Order processed: {order_id}"
        logger.info("Sending notification: %s", message)

        sns.publish(
            TopicArn=TOPIC_ARN,
            Message=message,
            Subject="Order Notification"
        )

    return {"status": "notification-sent"}