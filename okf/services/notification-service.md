---
type: Service
title: Notification Service
description: Outbound communication — email and push notifications.
resource: https://github.com/org/notification-service
tags: [communication, email, events, .net]
---

## Responsibility

Sends emails and push notifications in response to domain events and direct API calls.

## Publishes

None currently.

## Subscribes To

- [OrderShipped](/events/order-shipped.md) → sends confirmation email
- [PaymentFailed](/events/payment-failed.md) → sends retry notice
- [SubscriptionCancelled](/events/subscription-cancelled.md) → sends confirmation

## API

- `POST /api/notifications/email` — Send an email
- `GET /api/notifications/status/{id}` — Check delivery status

## Data

Templates, DeliveryLog
