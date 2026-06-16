---
type: Bundle
title: Platform Knowledge
description: Open Knowledge Format bundle describing the platform. Entry point for AI agents and humans.
---

# Platform Knowledge

This is the source of truth for what the platform IS. Every concept the AI
references must be documented here.

## Structure

The `catalog/` directory is a placeholder — rename it to match your domain,
and create additional directories as needed for different categories.

- [Catalog](catalog/index.md) — rename to `services/`, `events/`, `glossary/`, etc.

Each directory contains:
- `index.md` — lists the concepts in that category
- `_TEMPLATE.md` — copy this to create a new concept

See `README.md` for the full standard.

## How to Get Started

1. Read `README.md`.
2. Rename `catalog/` to your first category (e.g., `services/`).
3. Copy `_TEMPLATE.md` → `<name>.md`. Fill it in.
4. Create more categories as needed. Add them to this index.
5. Always link between related concepts.

## How to Use (for AI agents)

Start at this index. Follow links to the concepts you need.
Never read more than you need — each concept is its own file.
