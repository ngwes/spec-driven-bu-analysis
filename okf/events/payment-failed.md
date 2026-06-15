---
type: Event
title: PaymentFailed
description: Published when a payment attempt fails. Triggers retry notification.
publisher: Payments Service
tags: [payments, failure, notification]
---

## Publisher

[Payments Service](/services/payments-service.md)

## Subscribers

- [Orders Service](/services/orders-service.md) → marks order for review
- [Notification Service](/services/notification-service.md) → sends retry notice to customer

## Schema

| Field | Type | Description |
|-------|------|-------------|
| `paymentId` | string | The failed payment |
| `orderId` | string | The associated order |
| `reason` | string | Failure reason |
| `failedAt` | datetime | When failure occurred |
