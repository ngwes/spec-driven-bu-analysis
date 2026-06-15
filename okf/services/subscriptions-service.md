---
type: Service
title: Subscriptions Service
description: Recurring billing plans and subscription lifecycle management.
resource: https://github.com/org/subscriptions-service
tags: [subscriptions, billing, recurring, .net]
---

## Responsibility

Manages subscription plans, renewals, and cancellations.

## Publishes

- [SubscriptionRenewed](/events/subscription-renewed.md) — when a subscription renews
- [SubscriptionCancelled](/events/subscription-cancelled.md) — when a subscription is cancelled

## Subscribes To

None currently.

## API

- `POST /api/subscriptions` — Create subscription
- `GET /api/subscriptions/{id}` — Get subscription details
- `POST /api/subscriptions/{id}/cancel` — Cancel subscription

## Data

Subscriptions, Plans
