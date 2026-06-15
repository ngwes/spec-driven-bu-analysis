---
type: Event
title: SubscriptionCancelled
description: Published when a subscription is cancelled. Triggers confirmation notification.
publisher: Subscriptions Service
tags: [subscriptions, cancellation, notification]
---

## Publisher

[Subscriptions Service](/services/subscriptions-service.md)

## Subscribers

- [Notification Service](/services/notification-service.md) → sends confirmation

## Schema

| Field | Type | Description |
|-------|------|-------------|
| `subscriptionId` | string | The cancelled subscription |
| `customerId` | string | The customer |
| `cancelledAt` | datetime | When cancellation occurred |
| `reason` | string | Cancellation reason |
