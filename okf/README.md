---
type: README
title: OKF Bundle Guide
description: How to structure, populate, and maintain this Open Knowledge Format bundle.
---

# Open Knowledge Format — Guide

This bundle follows the [Google Open Knowledge Format](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing)
standard. It is the single source of truth for what the platform IS.

## Principles

**One concept = one file.** A file path is a concept's identity. Don't put
multiple concepts in one file.

**Minimal frontmatter.** Only `type` is required. Add `title`, `description`,
`tags`, `resource`, `timestamp` as needed.

**Markdown links connect concepts.** A file links to related concepts using
relative markdown links. This creates a navigable knowledge graph the AI
can traverse.

**Progressive disclosure.** Index files list concepts. The AI starts there
and follows links to only the files it needs. It never reads the whole bundle.

## Directory Convention

The bundle starts with a single placeholder directory. Rename it, duplicate it,
and create new ones to match your domain.

```
okf/
├── index.md            # Bundle entry point — lists all top-level categories
├── log.md              # Chronological change log — devs append one line per feature
├── README.md           # This file
├── catalog/            # PLACEHOLDER — rename to "services/", "events/", etc.
│   ├── index.md        # Lists concepts in this category
│   └── _TEMPLATE.md    # Copy this to create a new concept
├── <your-category>/    # Add your own categories
│   ├── index.md
│   └── _TEMPLATE.md
└── <another-category>/ # As many as your domain needs
    ├── index.md
    └── _TEMPLATE.md
```

Typical categories for a microservice platform:
- `services/` — one file per service
- `events/` — one file per domain event
- `glossary/` — one file per business term

But you decide. There is no fixed schema beyond one-concept-per-file.

## How to Start

1. Rename `catalog/` to your first category (e.g., `services/`).
2. Copy `_TEMPLATE.md` → `<concept-name>.md`.
3. Fill in the frontmatter (`type` is mandatory, all others optional).
4. Fill in the body — follow the suggestions in the template.
5. Link to related concepts using relative markdown links.
6. Add the concept to the directory's `index.md`.
7. Add the category to `okf/index.md`.
8. Repeat for each category you need.

## How to Add a New Category

```bash
mkdir okf/<category-name>
cp okf/catalog/_TEMPLATE.md okf/<category-name>/_TEMPLATE.md
# Create okf/<category-name>/index.md (copy from catalog/index.md as a starting point)
# Add the category to okf/index.md
```

## Concept File Naming

Use lowercase, hyphenated, `<name>.md`:
- `orders-service.md`
- `order-shipped.md`
- `customer.md`

## How to Maintain

### After a feature changes the platform

1. Dev appends one line to `okf/log.md`:
   ```
   2026-06-20: [category] Brief description of what changed
   ```
2. Dev runs `/speckit.okf-sync` — the AI reads the log, identifies affected
   concept files, and updates them.
3. If the feature added something entirely new, the AI suggests creating
   a new concept file.

### Manual updates

You can also edit concept files directly:
- Update related concept files that link to what you changed.
- Append a log entry if the change affects other teams.

## Validation

All concept files must have:
- [ ] YAML frontmatter with at least a `type` field
- [ ] A `title` in the frontmatter
- [ ] Links to related concepts in the bundle (where applicable)
- [ ] No broken internal links

## Reference

- [OKF Announcement (Google Cloud Blog)](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing)
