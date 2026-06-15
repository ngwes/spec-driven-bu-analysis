---
type: Event
title: OrderCancelled
description: Published when an order is cancelled. Triggers refund processing.
publisher: Orders Service
tags: [orders, cancellation, refund]
---

## Publisher

[Orders Service](/services/orders-service.md)

## Subscribers

- [Payments Service](/services/payments-service.md) → processes refund

## Schema

| Field | Type | Description |
|-------|------|-------------|
| `orderId` | string | The cancelled order |
| `customerId` | string | The customer |
| `cancelledAt` | datetime | When cancellation occurred |
| `reason` | string | Cancellation reason |
