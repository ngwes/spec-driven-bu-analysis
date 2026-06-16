---
# Copy this file. Rename to <concept-name>.md. Fill in the fields below.
# Delete this comment block before saving.
# The only required field is "type". All others are optional.

type: Concept
title: Name of the Concept
description: One sentence describing what this concept represents.
resource: https://link-to-source-if-applicable
tags: [tag1, tag2]
---

# Body

Describe the concept in freeform markdown. What sections you include
depends on the concept type — there is no mandatory body structure.

## Suggestions by concept type

### If this is a service
Describe its responsibility, what it publishes, what it subscribes to,
its API, and the data it owns. Link to related events and other services.

### If this is a domain event
Describe its publisher, subscribers, and the schema of its payload.
Link to the publishing and subscribing services.

### If this is a glossary term
Describe the business concept and how it maps to the technical implementation.
Link to the owning service and related events.

## Key rule

**Link to related concepts using relative markdown links.**
This creates the knowledge graph the AI traverses.

Example: `[Orders Service](../services/orders-service.md)`
