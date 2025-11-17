import json
import os
import uuid
import time
import boto3
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["ORDERS_TABLE"])

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    try:
        body = json.loads(event.get("body", "{}"))

        order_id = str(uuid.uuid4())
        timestamp = int(time.time())

        item = {
            "orderId": order_id,
            "customerId": body["customerId"],
            "productId": body["productId"],
            "quantity": body["quantity"],
            "price": body["price"],
            "currency": body["currency"],
            "createdAt": timestamp
        }

        table.put_item(Item=item)

        logger.info("Order created: %s", order_id)

        return {
            "statusCode": 201,
            "body": json.dumps({"orderId": order_id})
        }

    except Exception as e:
        logger.error("Error creating order: %s", str(e))
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}