---
type: GlossaryTerm
title: Customer
description: A person or organization that purchases through the platform.
tags: [identity, accounts]
---

## Technical Mapping

- **Entity:** `Customer` aggregate
- **Owned by:** [Customers Service](/services/customers-service.md)
- **Related Events:** None directly — referenced by other events via `customerId`

## Notes

Customers have profiles, addresses, communication preferences, and account status.
