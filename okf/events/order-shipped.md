---
type: Event
title: OrderShipped
description: Published when an order is marked as shipped. Triggers customer notification.
publisher: Orders Service
tags: [orders, shipping, notification]
---

## Publisher

[Orders Service](/services/orders-service.md)

## Subscribers

- [Notification Service](/services/notification-service.md) → sends confirmation email

## Schema

| Field | Type | Description |
|-------|------|-------------|
| `orderId` | string | The order that was shipped |
| `customerId` | string | The customer to notify |
| `shippedAt` | datetime | When shipping occurred |
| `trackingNumber` | string | Carrier tracking number |
