---
type: Event
title: PaymentConfirmed
description: Published when a payment is successfully processed.
publisher: Payments Service
tags: [payments, confirmation, fulfillment]
---

## Publisher

[Payments Service](/services/payments-service.md)

## Subscribers

- [Orders Service](/services/orders-service.md) → advances fulfillment

## Schema

| Field | Type | Description |
|-------|------|-------------|
| `paymentId` | string | The payment |
| `orderId` | string | The associated order |
| `amount` | decimal | Amount charged |
| `confirmedAt` | datetime | When payment was confirmed |
