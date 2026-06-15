---
type: Event
title: SubscriptionRenewed
description: Published when a subscription successfully renews. Triggers billing.
publisher: Subscriptions Service
tags: [subscriptions, renewal, billing]
---

## Publisher

[Subscriptions Service](/services/subscriptions-service.md)

## Subscribers

- [Payments Service](/services/payments-service.md) → charges customer

## Schema

| Field | Type | Description |
|-------|------|-------------|
| `subscriptionId` | string | The renewed subscription |
| `customerId` | string | The customer |
| `plan` | string | The plan name |
| `renewedAt` | datetime | When renewal occurred |
