---
type: Service
title: Orders Service
description: Order lifecycle management — creation, fulfillment, cancellation.
resource: https://github.com/org/orders-service
tags: [orders, transactional, .net]
---

## Responsibility

Manages the full order lifecycle. Publishes domain events at key state transitions.

## Publishes

- [OrderShipped](/events/order-shipped.md) — when shipping confirms
- [OrderCancelled](/events/order-cancelled.md) — when an order is cancelled

## Subscribes To

- [PaymentConfirmed](/events/payment-confirmed.md) — advances fulfillment
- [PaymentFailed](/events/payment-failed.md) — marks order for review

## API

- `POST /api/orders` — Create order
- `GET /api/orders/{id}` — Get order details
- `POST /api/orders/{id}/ship` — Mark as shipped

## Data

Orders, OrderItems, Shipments
