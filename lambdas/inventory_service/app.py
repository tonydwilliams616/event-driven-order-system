import json
import logging
import time

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    for record in event.get("Records", []):
        detail = record.get("detail", {})

        order_id = detail.get("orderId")
        product_id = detail.get("productId")
        quantity = detail.get("quantity")

        logger.info(
            "Updating inventory: product=%s qty=%s orderId=%s",
            product_id, quantity, order_id
        )

        time.sleep(0.5)

        logger.info("Inventory updated for product %s", product_id)

    return {"status": "inventory-updated"}