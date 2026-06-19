# Spec-Driven Setup

This repo contains the tooling to run spec-driven development with spec-kit
on an existing `.NET / Angular` microservice platform, designed for **business
analyst** autonomy with **OKF-grounded** AI.

## What's Inside

```
spec-driven/
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
├── brainstorm-extension/           # Extension: /speckit.brainstorm command
│   └── commands/
│       └── speckit.brainstorm.md
├── review-extension/               # Extension: /speckit.create-review + /speckit.review
│   └── commands/
│       ├── speckit.create-review.md
│       └── speckit.review.md
├── hooks/
│   └── pre-commit.ps1               # PowerShell hook: auto-update AGENTS.md on version tags
├── skills/
│   └── update-agents/
│       └── SKILL.md                 # Manual skill: update AGENTS.md via subagent
├── okf/                            # Open Knowledge Format (Google OKF standard)
│   ├── README.md                   # How to structure, populate, maintain
│   ├── index.md                    # Bundle entry point
│   ├── log.md                      # Change log — devs write here
│   └── catalog/                    # PLACEHOLDER — rename for your domain
│       ├── index.md                # Category listing
│       └── _TEMPLATE.md            # Copy to create a concept
└── constitution.md                 # OKF grounding rules (→ .specify/memory/)
```

## Setup (once per project)

### 1. Initialize spec-kit

```bash
# With Claude Code
specify init spec-driven --ai claude

# Or with GitHub Copilot
specify init spec-driven --ai copilot

cd spec-driven
```

### 2. Copy the OKF

Move `okf/` into the spec-driven repo:

```bash
cp -r okf/ ./
```

Populate the OKF with your actual services, events, and glossary.
Copy `_TEMPLATE.md` in each directory to get started. See `okf/README.md` for the full guide.

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

### 6. Install the brainstorm extension

```bash
cp -r brainstorm-extension/ .specify/extensions/brainstorm/
```

### 7. Install the review extension

```bash
cp -r review-extension/ .specify/extensions/review/
```

## Daily Workflow

### BA: Understanding the platform

```
/speckit.explore Can we send emails to customers?
/speckit.explore What happens when a payment fails?
/speckit.explore Which services deal with subscriptions?
```

All answers grounded in the OKF. No invented capabilities.

### BA: Brainstorming an idea (optional, before writing a spec)

```
/speckit.brainstorm I'm thinking about better notifications for customers.
```

Freeform dialog. The AI tests ideas against the OKF, flags impossible things,
suggests platform-native alternatives. When done, the AI offers to save notes
in `brainstorms/YYYY-MM-DD-<topic>.md` — always the same directory.

### BA: Writing a spec

```
/speckit.specify I want customers to get an email when their order ships.
```

The AI asks one question at a time. Before writing `spec.md`, it produces a
**draft** for review. The BA adds inline comments with `<!-- -->`. Loop until
approved, then the AI writes the final artifact.

### BA: Refining a spec (any time)

```
/speckit.clarify
```

The AI reads the current spec, finds ambiguities, dialogs through them.
Produces a draft first, applies clarifications on approval.

### BA: Breaking into tasks

```
/speckit.tasks
```

The AI breaks the spec into tasks story by story, dialoguing with the BA.
Produces a draft first, writes `tasks.md` on approval.

### Handoff: spec.md + tasks.md

The BA delivers two files. The dev reviews them, optionally runs
`/speckit.plan` for technical architecture, then `/speckit.implement`.

### Review loop: when something is off

If the dev (or BA) finds issues after the spec is done, it enters a review loop.
Originals are never overwritten — each resolution creates a new version linked
to the previous.

**Creating a review (BA or Dev):**

```
/speckit.create-review
```

The AI asks which spec, then collects issues one at a time. Draft first, writes `review.md` on approval.

**Resolving a review (BA):**

```
/speckit.review
```

The AI asks which spec + which review(s) to apply. Walks through issues one
at a time. Draft first, writes `spec-vN.md` on approval, linking back to the
original. The review is marked as resolved.

**The chain:**

```
spec.md  →  review.md  →  spec-v2.md  →  review-2.md  →  spec-v3.md
  (v1)                     (links v1)                    (links v2)
```

Full traceability. Nothing is ever lost.

### After implementation

Each service repo's `AGENTS.md` must stay current so the AI always grounds
in reality. See [Maintaining AGENTS.md](#maintaining-agentsmd) at the end
for the three automation approaches.

## Architecture

```
┌──────────────────────────────────────────┐
│           CONSTITUTION                    │
│  OKF grounding — mandatory, all phases   │
└────────────────┬─────────────────────────┘
                 │
    ┌────────────┴────────────┐
    ▼                         ▼
 BA SIDE                          DEV SIDE
 /speckit.brainstorm   (dialog)     /speckit.plan
 /speckit.explore                 /speckit.implement
 /speckit.specify    (dialog)     /speckit.create-review
 /speckit.clarify    (dialog)
 /speckit.tasks      (dialog)
 /speckit.create-review           ──┐
 /speckit.review      (dialog)      ├── review loop
                                    │   (both sides)
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

## How to Test

Spin up spec-kit with all extensions and validate end-to-end.

### Prerequisites

```bash
# Install spec-kit CLI
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# Verify
specify --version
```

### 1. Create a test project

```bash
cd /tmp
specify init spec-driven-test --ai claude   # or --ai copilot
cd spec-driven-test
```

### 2. Install everything

```bash
# OKF
cp -r /path/to/spec-kit/okf/ ./

# Constitution
cp /path/to/spec-kit/constitution.md .specify/memory/constitution.md

# Preset
specify preset add --dev /path/to/spec-kit/ba-friendly

# Extensions
cp -r /path/to/spec-kit/explore-extension/   .specify/extensions/explore/
cp -r /path/to/spec-kit/brainstorm-extension/ .specify/extensions/brainstorm/
cp -r /path/to/spec-kit/review-extension/    .specify/extensions/review/
```

### 3. Validate the BA flow

```bash
# In your AI agent (Claude Code), test each command:

# Explore the platform
/speckit.explore What services handle orders?

# Brainstorm a feature
/speckit.brainstorm I want customers to get push notifications when orders ship.

# Write the spec
/speckit.specify Push notification on order shipped

# Refine
/speckit.clarify

# Break into tasks
/speckit.tasks
```

### 4. Validate the review loop

```bash
# Create a review (dev side)
/speckit.create-review

# Resolve the review (BA side)
/speckit.review
```

### 5. Validate OKF grounding

```bash
# Should find existing capabilities
/speckit.explore Can we send emails?

# Should flag gaps
/speckit.explore Can we send SMS?

# The specify phase should flag:
/speckit.specify Customers should get an SMS when they sign up.
# → AI should say: "SMS is not in the OKF. This is a gap."
```

### What to check

| Test | Expected |
|------|----------|
| `/speckit.explore` | Answers cite OKF files. Says "not in OKF" for unknowns. |
| `/speckit.brainstorm` | Dialog, one question at a time. Offers to save to `brainstorms/`. |
| `/speckit.specify` | One question at a time. Flags OKF gaps. Draft → review → approve → spec.md. |
| `/speckit.clarify` | Reads spec, finds ambiguities, dialogs. Draft → approve → updated spec.md. |
| `/speckit.tasks` | Breaks spec story by story. Draft → approve → tasks.md. |
| `/speckit.create-review` | Collects issues one at a time. Draft → approve → review.md. |
| `/speckit.review` | Resolves issues one at a time. Draft → approve → spec-vN.md with back-link. |
| Constitution | All commands read from `okf/` before responding. |
| OKF sync (WIP)| `okf/log.md` entries updated after sync. Only changed files touched. |

## Future Enhancements

### Visual Plan Review with Plannotator

Currently, the plan-first cycle uses `<!-- HTML comments -->` for draft annotations.
A future enhancement is integrating [Plannotator](https://github.com/backnotprop/plannotator)
for a richer review experience:

- **Browser-based review UI** — BAs review drafts in a clean visual interface, no markdown editing
- **VS Code extension available** — open plans in editor tabs with gutter annotations
- **Inline annotations with approve/deny** — click a section, leave feedback, approve or send back for revision
- **Multiplayer** — BA and dev can annotate the same plan together
- **Agent integration** — hooks into spec-kit's lifecycle, feedback goes directly back to the AI agent

Status: **Nice to have.** The `<!-- -->` approach works today; Plannotator would
upgrade the review UX once the workflow is validated.

### Codebase Indexing

Instead of (or in addition to) maintaining an OKF bundle, a codebase indexer
can let the AI search across all service repos directly. The index provides
reach; AGENTS.md provides meaning. Together they may eliminate the need for OKF.

Tools (lightweight to enterprise):

| Tool | Stack | Languages | Setup | Key feature |
|------|-------|-----------|:--:|-------------|
| [codemogger](https://github.com/glommer/codemogger) | SQLite + tree-sitter WASM | 13 lang | Minutes | Single `.db` file, 25-370x faster than grep |
| [Lore](https://www.npmjs.com/package/@jafreck/lore) | SCIP + SQLite + ONNX embeddings | 23 lang | Hour | +5.6pp accuracy, -30% tokens, git blame |
| [knot](https://github.com/raultov/knot) | Neo4j + Qdrant (graph + vector) | 9+ lang | Hour | Dual database, cross-repo dependencies |
| [Infigraph](https://intuit.github.io/infigraph/) | Knowledge graph + BM25 | 62 lang | Hour | Zero LLM dependency, fully offline |
| [Serena](https://github.com/oraios/serena) | LSP / JetBrains + MCP, symbol-level | 40+ lang | Minutes | Refactoring, debugging, cross-session memory |
| [Sourcegraph](https://sourcegraph.com/mcp) | SCIP + MCP + Deep Search | All | Days | Enterprise cross-repo, semantic + historical |

All expose an **MCP server** — plug into Claude Code, Copilot, or any agent.
The [SCIP protocol](https://github.com/sourcegraph/scip) is becoming the open
standard for precise code indexing (backed by Uber, Meta, Sourcegraph).

Status: **Future exploration.** Start with codemogger for a quick test.
Add Lore or knot if cross-repo dependency tracking is needed.

### The Plan-First Pattern

All artifact-producing commands follow the same cycle:

```
AI dialogs → drafts → user reviews → approved → artifact
                   ↑                                 │
                   └── user comments with <!-- --> ──┘
```

1. **Draft.** AI writes a temporary file (`draft-spec.md`, `draft-tasks.md`, etc.)
2. **Review.** User reads it, adds inline comments using HTML comments:
   ```markdown
   <!-- Should this be P2 instead? -->
   <!-- What about the edge case where the user has no email? -->
   ```
3. **Iterate.** User says "reviewed." AI reads every comment, updates the draft.
4. **Approve.** User says "approved." AI writes the final artifact, deletes the draft.

No artifact is written without a reviewed plan. Every draft is disposable.

---

## Maintaining AGENTS.md

Each service repo has an `AGENTS.md` that tells AI agents how to work on
that service. It must stay current or the AI grounds in stale information.
Three approaches, from most automated to most manual.

### Approach 1: Pre-Commit Hook (PowerShell)

Fires automatically when a commit message contains `tag.` (the version-tag
pattern used at the end of a development cycle).

```
Dev finishes feature → version commit "tag.v1.2.3: add refund support"
                              │
                     pre-commit hook fires
                              │
                Hook: git diff main...HEAD
                Agent (Copilot or Claude) updates AGENTS.md
                Updated file staged automatically
```

**Script:** [`hooks/pre-commit.ps1`](hooks/pre-commit.ps1)

```powershell
# Default (Copilot)
.\.githooks\pre-commit.ps1

# With a specific model
.\.githooks\pre-commit.ps1 -Model gpt-4o

# With Claude
.\.githooks\pre-commit.ps1 -Agent claude -Model opus

# Skip when in a hurry
git commit --no-verify
```

**Pros:** Automatic — dev doesn't need to remember. **Cons:** Adds latency
to the commit (LLM response time). The `--no-verify` escape hatch mitigates this.

**Setup per repo:**

1. Copy the hook script into the repo:
   ```powershell
   cp \path\to\spec-kit\hooks\pre-commit.ps1 .githooks\
   ```

2. Configure Git to use the `.githooks` directory:
   ```powershell
   git config core.hooksPath .githooks
   ```

3. Verify the hook is executable and the agent CLI is available:
   ```powershell
   # Test: Copilot must be authenticated
   gh auth status

   # Or: Claude must be installed
   claude --version
   ```

4. Test with a dry run:
   ```powershell
   .\.githooks\pre-commit.ps1 -DryRun
   ```

5. The hook only fires on commit messages containing `tag.` — all other
   commits pass through instantly. No latency for normal work.

**CI equivalent (if permitted):** Move the script to a GitHub Actions /
Azure DevOps pipeline triggered on push to main. Remove the hook. Same
logic, zero dev machine impact.

### Approach 2: Manual Skill

Dev runs a skill at the end of development instead of relying on a hook.

```
/speckit.update-agents
```

**Skill:** [`skills/update-agents/SKILL.md`](skills/update-agents/SKILL.md)

Launches a subagent that runs `git diff main...HEAD`, reads AGENTS.md,
updates only the affected sections, and presents the result for review
before committing.

**Pros:** Full control — dev reviews before commit. No hook latency.
**Cons:** Dev must remember to run it.

### Approach 3: CI Pipeline (ideal, if permitted)

Moves the work entirely off the developer's machine:

```
Push to main → CI job starts
    → Agent reads git diff against previous main
    → Agent updates AGENTS.md if surface changed
    → Agent pushes updated AGENTS.md back
    → Agent triggers central OKF aggregator sync
```

**Why it's the best option:**

- **Zero developer burden** — no hooks, no skills, no remembering
- **Reliable** — monitored, logged, failures are visible
- **Atomic per push** — every merged PR gets its update
- **Cross-repo alignment** — CI in the central aggregator repo can
  automatically pull all service repo AGENTS.md files on a schedule,
  regenerate the central OKF bundle, and keep the BA-facing knowledge
  always in sync with reality — no manual `/speckit.okf-sync` needed

**The only blocker:** company policy may prohibit AI agents in CI pipelines.
If permitted, prefer this approach. It eliminates the maintenance burden entirely.

### Comparison

| Approach | Trigger | Review | Dev burden | Cross-repo sync |
|----------|---------|:--:|:--:|:--:|
| Pre-commit hook | `tag.` in commit | Immediate | None (but latency) | Manual |
| Manual skill | Dev discretion | Pre-commit | Must remember | Manual |
| CI pipeline | Push to main | Post-hoc | Zero | Automatic |