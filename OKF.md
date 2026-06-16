# Open Knowledge Format — Step-by-Step Guide

A practical guide to building and maintaining an OKF bundle for your platform.
Based on the [Google Open Knowledge Format](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing) standard.

## What Is the Open Knowledge Format?

OKF is an open, vendor-neutral specification for packaging knowledge that both
AI systems and humans can read. Think of it as a **LLM-wiki** — a structured,
machine-readable knowledge base built from plain markdown files.

An OKF **bundle** is just a directory of markdown files. No database. No SDK.
No proprietary format. Just files.

## Core Principles

### 1. One Concept = One File

Every "thing" the AI should know about gets its own file. The file path IS the
concept's identity.

```
❌ Wrong:  okf/services.md         (all services in one file)
✅ Right:  okf/services/orders-service.md
           okf/services/payments-service.md
           okf/services/notification-service.md
```

### 2. YAML Frontmatter for Structure

Each file starts with a small YAML block. Only `type` is required. Everything
else is optional but recommended.

```yaml
---
type: Service                          # REQUIRED — what kind of concept
title: Orders Service                  # Human-readable name
description: Manages order lifecycle   # One-sentence summary
resource: https://github.com/org/orders  # Link to source
tags: [orders, transactional]          # Search/filter keywords
timestamp: 2026-06-15T10:00:00Z        # Last updated
---
```

### 3. Markdown Links Create the Knowledge Graph

Link between concepts using relative markdown links. This is what makes the
OKF navigable — the AI follows links to discover related knowledge.

```markdown
## Publishes
- [OrderShipped](../events/order-shipped.md) — when shipping confirms

## Subscribes To
- [PaymentConfirmed](../events/payment-confirmed.md) — advances fulfillment
```

### 4. Progressive Disclosure via Index Files

Each directory has an `index.md` that lists its concepts. The AI starts at the
index and follows links to only the files it needs. It never reads the whole
bundle.

```
okf/
├── index.md            ← Entry: "Services, Events, Glossary"
├── services/
│   ├── index.md        ← Lists all services. AI reads this first.
│   ├── orders-service.md   ← AI only reads this if relevant
│   └── payments-service.md
```

---

## Step 1: Scaffold Your Bundle

Start from the template in this repo:

```bash
cp -r okf/ my-project-okf/
cd my-project-okf/
```

You now have:
```
okf/
├── README.md           # Reference guide
├── index.md            # Bundle entry point
├── log.md              # Change log
└── catalog/            # PLACEHOLDER — rename for your first category
    ├── index.md
    └── _TEMPLATE.md
```

## Step 2: Define Your Categories

Decide what kinds of "things" make up your platform. Common categories for a
microservice system:

| Category | Directory | What goes in it |
|----------|-----------|-----------------|
| Services | `services/` | One file per service: responsibility, API, events |
| Events | `events/` | One file per domain event: publisher, subscribers, schema |
| Glossary | `glossary/` | One file per business term: mapping to technical concepts |
| APIs | `apis/` | Public API contracts, authentication, rate limits |
| Data Models | `data-models/` | Key entities, relationships, ownership |

Rename `catalog/` to your first category, then create additional directories:

```bash
mv catalog/ services/
mkdir events/ glossary/
```

For each new directory, copy the `_TEMPLATE.md` and create an `index.md`:

```bash
cp services/_TEMPLATE.md events/_TEMPLATE.md
cp services/index.md events/index.md
# Edit events/_TEMPLATE.md for event-specific fields
# Edit events/index.md to list events
```

## Step 3: Add Your First Concepts

Start with your most important services — they're the backbone. For each:

```bash
cp services/_TEMPLATE.md services/orders-service.md
```

Open the file and fill it in. Here's a real example:

```markdown
---
type: Service
title: Orders Service
description: Order lifecycle — creation, fulfillment, cancellation.
resource: https://github.com/org/orders-service
tags: [orders, transactional]
---

## Responsibility
Manages the full order lifecycle. Publishes domain events at key transitions.

## Publishes
- [OrderShipped](../events/order-shipped.md) — when shipping confirms
- [OrderCancelled](../events/order-cancelled.md) — when cancelled

## Subscribes To
- [PaymentConfirmed](../events/payment-confirmed.md) — advances fulfillment

## API
- `POST /api/orders` — Create order
- `GET /api/orders/{id}` — Get order details
- `POST /api/orders/{id}/ship` — Mark shipped

## Data
Orders, OrderItems, Shipments
```

**Key discipline:** The moment you reference another concept (like an event),
create that file too — even if it's a stub. Broken links break the AI's
ability to navigate.

## Step 4: Keep Index Files Current

Every time you add a concept, add it to the directory's `index.md`:

```markdown
# Service Catalog

## Services

- [Orders Service](orders-service.md)
- [Payments Service](payments-service.md)
- [Notification Service](notification-service.md)
```

And add the directory itself to `okf/index.md`:

```markdown
## Structure

- [Services](services/index.md) — Service catalog
- [Events](events/index.md) — Domain event catalog
- [Glossary](glossary/index.md) — Business terms
```

## Step 5: Establish the Maintenance Rhythm

### After every feature that changes the platform

The developer appends one line to `okf/log.md`:

```
2026-06-20: [payments] Added partial refund support, new RefundIssued event
```

Then runs `/speckit.okf-sync`. The AI:
1. Reads the new log entry
2. Identifies which concept files need updating
3. Updates only those files (typically 1-3)
4. Marks the entry as synced ✅

### Periodic validation

Run a quick link check to catch broken references:

```bash
# Check that every link in the OKF points to an existing file
grep -r '\[.*\](.*\.md)' okf/ | while read line; do
  # Extract the link target
  target=$(echo "$line" | grep -oP '(?<=\]\().*?(?=\))')
  # Verify it exists
  [ -f "okf/$target" ] || echo "BROKEN: $line"
done
```

---

## The Frontmatter Fields

Only `type` is required by the standard. These are the commonly used fields:

| Field | Required | Description |
|-------|----------|-------------|
| `type` | ✅ | Concept type: `Service`, `Event`, `GlossaryTerm`, `API`, etc. |
| `title` | | Human-readable name |
| `description` | | One-sentence summary |
| `resource` | | URL to the source (repo, doc, dashboard) |
| `tags` | | Keywords for search/filtering |
| `timestamp` | | ISO 8601 date of last update |
| `publisher` | | (Events) Which service publishes this event |

You can add your own fields. The standard is minimally opinionated.

## The Body

Freeform markdown. No mandatory structure. But consistency helps both humans
and AI. Pick a pattern per concept type and stick to it.

**Service pattern:**
```markdown
## Responsibility
## Publishes
## Subscribes To
## API
## Data
```

**Event pattern:**
```markdown
## Publisher
## Subscribers
## Schema
```

**Glossary term pattern:**
```markdown
## Technical Mapping
## Notes
```

## File Naming Conventions

- Lowercase, hyphenated: `orders-service.md`, `order-shipped.md`
- One word? Still lowercase: `customer.md`, `order.md`
- No version numbers or dates in filenames — that's what `log.md` is for
- `_TEMPLATE.md` and `index.md` are special — don't rename them

## How the AI Uses It

When someone runs `/speckit.specify` or `/speckit.explore`:

1. AI reads `okf/index.md` — discovers categories
2. AI reads relevant `index.md` files — discovers concepts
3. AI follows links to the 3-5 concept files relevant to the query
4. AI NEVER reads the entire bundle

This means:
- Keep concept files **small and focused** (~15-30 lines each)
- Put the most important information at the **top**
- Use **descriptive titles** — the AI sees these in index listings first

## Reference

- [Google OKF Announcement](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing)
- [OKF Bundle in this repo](./okf/) — working template
- [okf/README.md](./okf/README.md) — reference guide for the bundle itself
