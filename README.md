# Event-Driven Order Processing System (AWS Serverless)

An end-to-end **event-driven architecture** built on **AWS serverless services** to simulate an e-commerce order processing pipeline.

This project is designed as a **portfolio piece for recruiters**: it demonstrates real-world cloud architecture, event-driven design, infrastructure-as-code, and observability.

---

## 🧠 High-Level Overview

A client creates an order via an HTTP API. The order is written to DynamoDB, which emits a change event via DynamoDB Streams. That event is published to an EventBridge bus, which then **fans out** to multiple independent services:

- **Payment Service** – simulates charging a customer
- **Inventory Service** – simulates stock updates
- **Notification Service** – sends order confirmation / failure notifications
- (Optional) **Analytics / Audit Service** – pushes events to S3 for querying with Athena

All of this happens in a **loosely coupled**, **event-driven** way.

---

## 🏗️ Architecture Diagram

```mermaid
flowchart LR
    subgraph Client
        U[User / Postman / Frontend]
    end

    subgraph AWS
        APIGW[API Gateway<br/>/orders endpoint]
        L1[Lambda<br/>createOrder]
        DDB[(DynamoDB<br/>Orders table)]
        DDBS[(DynamoDB Streams)]
        EB[EventBridge<br/>Event Bus]

        subgraph Consumers
            L2[Lambda<br/>Payment Service]
            L3[Lambda<br/>Inventory Service]
            L4[Lambda<br/>Notification Service]
            L5[Lambda<br/>Analytics / Audit Service]
        end

        SNS[(SNS / SES<br/>Notifications)]
        S3[(S3 Bucket<br/>Order Events)]
    end

    U --> APIGW --> L1 --> DDB
    DDB --> DDBS --> EB

    EB --> L2
    EB --> L3
    EB --> L4
    EB --> L5

    L4 --> SNS
    L5 --> S3