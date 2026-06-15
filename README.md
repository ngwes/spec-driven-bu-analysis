# Spec-Drive Setup

This repo contains the tooling to run spec-driven development with spec-kit
on an existing `.NET / Angular` microservice platform, designed for **business
analyst** autonomy with **OKF-grounded** AI.

## What's Inside

```
spec-drive/
├── ba-friendly/                    # Preset: conversational specify, clarify, tasks
│   ├── preset.yml
│   ├── commands/
│   │   ├── speckit.specify.md
│   │   ├── speckit.clarify.md
│   │   └── speckit.tasks.md
│   └── README.md
├── explore-extension/              # Extension: /speckit.explore command
│   └── commands/
│       └── speckit.explore.md
├── okf/                            # Open Knowledge Format (Google OKF standard)
│   ├── index.md                    # Bundle entry point
│   ├── log.md                      # Change log — devs write here
│   ├── glossary/                   # One file per business term
│   │   ├── index.md
│   │   ├── order.md
│   │   ├── customer.md
│   │   └── subscription.md
│   ├── services/                   # One file per service
│   │   ├── index.md
│   │   ├── orders-service.md
│   │   ├── notification-service.md
│   │   └── [more services].md
│   └── events/                     # One file per event
│       ├── index.md
│       ├── order-shipped.md
│       ├── payment-confirmed.md
│       └── [more events].md
└── constitution.md                 # OKF grounding rules (→ .specify/memory/)
```

## Setup (once per project)

### 1. Initialize spec-kit

```bash
specify init spec-drive --ai claude
cd spec-drive
```

### 2. Copy the OKF

Move `okf/` into the spec-drive repo:

```bash
cp -r okf/ ./
```

Populate the OKF with your actual services, events, and glossary.
Use the examples as a template.

### 3. Add the constitution

Copy `constitution.md` into spec-kit's memory:

```bash
cp constitution.md .specify/memory/constitution.md
```

### 4. Install the ba-friendly preset

```bash
specify preset add --dev ./ba-friendly
```

### 5. Install the explore extension

Copy the extension into spec-kit's extensions directory:

```bash
cp -r explore-extension/ .specify/extensions/explore/
```

## Daily Workflow

### BA: Understanding the platform

```
/speckit.explore Can we send emails to customers?
/speckit.explore What happens when a payment fails?
/speckit.explore Which services deal with subscriptions?
```

All answers grounded in the OKF. No invented capabilities.

### BA: Writing a spec

```
/speckit.specify I want customers to get an email when their order ships.
```

The AI asks one question at a time. Iterates. Produces spec.md.

### BA: Refining a spec (any time)

```
/speckit.clarify
```

The AI reads the current spec, finds ambiguities, dialogs through them.

### BA: Breaking into tasks

```
/speckit.tasks
```

The AI breaks the spec into tasks story by story, dialoguing with the BA
to confirm the breakdown. Produces tasks.md.

### Handoff: spec.md + tasks.md

The BA delivers two files. The dev reviews them, optionally runs
`/speckit.plan` for technical architecture, then `/speckit.implement`.

### After implementation: Maintain AGENTS.md

Each service repo has an `AGENTS.md` that the AI reads to understand that
service. It must stay current. Multiple approaches, pick what fits:

#### Approach A: Git-log-driven (recommended)

AGENTS.md self-tracks the commit it was last updated from:

```markdown
---
last-updated-commit: abc123def
---
```

A skill in the service repo (`/update-agents`) reads the git log from that
commit to HEAD on main, summarizes the changes, and updates AGENTS.md:

```
Dev runs: /update-agents

Skill does:
  1. Reads last-updated-commit from AGENTS.md frontmatter
  2. Runs: git log <last-updated-commit>..origin/main --oneline
  3. Summarizes the commits into AGENTS.md sections
  4. Updates last-updated-commit to HEAD
  5. Dev reviews, commits the updated AGENTS.md
```

**Cost:** one slash command. No manual writing.

#### Approach B: Spec-implement-driven

After `/speckit.implement` finishes in the service repo, the AI that
implemented the feature already knows exactly what changed. It can
update AGENTS.md directly as the final implementation step.

**Cost:** zero extra steps. AGENTS.md is a byproduct of implementation.

#### Approach C: Manual

Dev writes a brief summary of changes directly in AGENTS.md after
completing a feature.

**Cost:** 2-3 sentences of writing. Highest friction, but full control.

### After AGENTS.md is updated: Sync to OKF

The OKF in the spec-drive repo is the aggregated, cross-repo knowledge graph.
Once AGENTS.md is current, the dev triggers the OKF sync in the spec-drive repo:

```
/speckit.okf-sync
```

The AI:
1. Reads the updated AGENTS.md from the service repo
2. Identifies which OKF concept files are affected
3. Updates only those files (1-3 files, not the whole bundle)
4. Appends an entry to `okf/log.md` recording the change

**Total cost per feature:** 1-2 slash commands. No manual OKF editing.

## Architecture

```
┌──────────────────────────────────────────┐
│           CONSTITUTION                    │
│  OKF grounding — mandatory, all phases   │
└────────────────┬─────────────────────────┘
                 │
    ┌────────────┴────────────┐
    ▼                         ▼
 BA SIDE                   DEV SIDE
 /speckit.explore          /speckit.plan
 /speckit.specify (dialog) /speckit.implement
 /speckit.clarify (dialog)
 /speckit.tasks   (dialog)

     └── HANDOFF ──→ spec.md + tasks.md
    │                         │
    ▼                         ▼
        ALL grounded in OKF
    ┌─────────────────────────┐
    │  okf/   (OKF standard)   │
    │  index.md → progressive  │
    │  log.md   → change log   │
    │  glossary/  services/    │
    │  events/    1 file per   │
    │             concept      │
    └─────────────────────────┘
```
