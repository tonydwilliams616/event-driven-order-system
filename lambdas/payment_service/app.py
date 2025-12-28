import json
import logging
import random
import time

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    for record in event.get("Records", []):
        detail = (
            json.loads(record.get("body", "{}"))
            if "body" in record
            else record.get("detail", {})
        )

        order_id = detail.get("orderId")
        if not order_id:
            continue

        logger.info("Processing payment for order: %s", order_id)

        time.sleep(1)  # simulate processing delay

        success = random.choice([True, True, False])  # 66% success rate

        if success:
            logger.info("Payment succeeded for %s", order_id)
        else:
            logger.warning("Payment FAILED for %s", order_id)

    return {"status": "processed"}
