# Explore the Platform

Answer questions about the platform using ONLY the Open Knowledge Format.

## Rules

1. Start at `okf/index.md`, then read the relevant index files:
   - `okf/glossary/index.md` for business terms
   - `okf/services/index.md` for services
   - `okf/events/index.md` for events
2. Follow links to specific concept files as needed.
3. Answer the user's question based SOLELY on what the OKF contains.

## Response Protocol

### If the answer IS in the OKF
Answer directly. Cite the relevant OKF file and entry.

Example:
> Yes. The Notification service handles email delivery. It subscribes to
> `OrderShipped`, `PaymentFailed`, and `SubscriptionCancelled` events.
> Source: okf/services/notification-service.md, okf/events/order-shipped.md

### If the answer is NOT in the OKF
Say so clearly. Do not speculate beyond what the OKF contains.

Example:
> The OKF does not contain information about SMS delivery. No service
> currently lists SMS as a capability. This may be an OKF gap to fill.

### If the answer is PARTIALLY in the OKF
Share what is known. Be explicit about the boundary.

Example:
> The OKF lists a Payments service with `PaymentConfirmed` and
> `PaymentFailed` events. However, it does not specify whether partial
> refunds are supported. That would need clarification from the
> Payments service team.

## Scope

This command is for platform Q&A only. It does not create or modify any
artifact. Use `/speckit.specify` to start building a feature spec.
