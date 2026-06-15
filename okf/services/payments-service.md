---
type: Service
title: Payments Service
description: Payment processing, refunds, and billing.
resource: https://github.com/org/payments-service
tags: [payments, billing, transactional, .net]
---

## Responsibility

Processes payments, handles refunds, and publishes payment outcome events.

## Publishes

- [PaymentConfirmed](/events/payment-confirmed.md) — when a charge succeeds
- [PaymentFailed](/events/payment-failed.md) — when a charge fails

## Subscribes To

- [OrderCancelled](/events/order-cancelled.md) → processes refund
- [SubscriptionRenewed](/events/subscription-renewed.md) → charges customer

## API

- `POST /api/payments/charge` — Process a payment
- `POST /api/payments/refund` — Issue a refund
- `GET /api/payments/{id}` — Get payment status

## Data

Transactions, PaymentMethods
