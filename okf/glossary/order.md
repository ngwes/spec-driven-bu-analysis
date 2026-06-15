---
type: GlossaryTerm
title: Order
description: A customer's purchase — the core transactional aggregate.
tags: [sales, transactional]
---

## Technical Mapping

- **Entity:** `Order` aggregate
- **Owned by:** [Orders Service](/services/orders-service.md)
- **Related Events:** [OrderShipped](/events/order-shipped.md), [OrderCancelled](/events/order-cancelled.md)

## Notes

An order moves through states: Created → Paid → Fulfilling → Shipped → Delivered.
It may also transition to Cancelled or Refunded.
