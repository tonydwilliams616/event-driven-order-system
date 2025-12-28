resource "aws_iam_role" "pipe_role" {
  name = "${var.name}-pipe-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "pipes.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "pipe_policy" {
  name = "${var.name}-pipe-policy"
  role = aws_iam_role.pipe_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Read DynamoDB Stream
      {
        Effect: "Allow",
        Action: [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams"
        ],
        Resource: var.dynamodb_stream_arn
      },

      # Write to EventBridge
      {
        Effect: "Allow",
        Action: [
          "events:PutEvents"
        ],
        Resource: var.event_bus_arn
      }
    ]
  })
}

resource "aws_pipes_pipe" "this" {
  name     = var.name
  role_arn = aws_iam_role.pipe_role.arn

  source = var.dynamodb_stream_arn
  target = var.event_bus_arn

  source_parameters {
    dynamodb_stream_parameters {
      starting_position = "LATEST"
    }
  }

  target_parameters {
    input_template = <<EOF
{
  "source": "custom.orders",
  "detail-type": "OrderCreated",
  "detail": {
    "orderId": <$.dynamodb.NewImage.orderId.S>,
    "customerId": <$.dynamodb.NewImage.customerId.S>,
    "productId": <$.dynamodb.NewImage.productId.S>,
    "quantity": <$.dynamodb.NewImage.quantity.N>,
    "price": <$.dynamodb.NewImage.price.N>,
    "currency": <$.dynamodb.NewImage.currency.S>
  }
}
EOF
  }
}