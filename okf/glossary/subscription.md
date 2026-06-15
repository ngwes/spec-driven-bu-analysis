---
type: GlossaryTerm
title: Subscription
description: A recurring plan a customer pays for on a schedule.
tags: [billing, recurring]
---

## Technical Mapping

- **Entity:** `Subscription` aggregate
- **Owned by:** [Subscriptions Service](/services/subscriptions-service.md)
- **Related Events:** [SubscriptionRenewed](/events/subscription-renewed.md), [SubscriptionCancelled](/events/subscription-cancelled.md)

## Notes

Plans determine billing frequency and amount. States: Active, PastDue, Cancelled, Expired.
