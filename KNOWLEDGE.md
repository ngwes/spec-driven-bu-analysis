# Maintaining AGENTS.md and OKF Bundles — Practical Knowledge

What works, what doesn't, and how teams keep these alive in production.

## AGENTS.md: The Repo-Level Agent Instructions

### What It Is

A plain markdown file at the repo root that gives AI coding agents (Claude Code,
Copilot, Cursor, Codex, etc.) the context they need: build commands, architecture,
rules, and boundaries. No YAML frontmatter. No schema. No build step.

### Sizing: 100-150 Lines Max

Files above ~250 lines get skim-read by both humans and agents. Research from
Augment Code found that **100-150 lines + a few focused reference docs**
delivers a 10-15% cross-metric improvement. Beyond that, performance reverses.

A well-maintained AGENTS.md was measured to improve task speed by **28.6%**
and reduce token usage by **16.6%** — roughly a free model upgrade. But a stale
or bloated one actively hurts.

### What To Put In It

| Section | Content | Why |
|---------|---------|-----|
| **Project Overview** | 3-5 lines: what, language, framework, consumers | Agents need the big picture |
| **Commands** | Copy-pasteable: install, dev, test, lint, codegen | Most common agent mistake: wrong command |
| **Architecture** | Directory map: where things live | Agents navigate by convention |
| **Code Style** | Only rules that differ from language defaults (5-15) | Don't repeat what tsconfig says |
| **Testing Strategy** | Ordered by priority with exact commands | Agents default to wrong test runner |
| **Do-Not-Touch List** | Generated code, vendored deps, migrations | Prevents the #1 agent disaster |
| **Git Workflow** | Branch naming, commit format | Consistency |
| **Principles** | 3-7 non-negotiable rules | Fallback when no other rule applies |

### What NOT To Put In

| Don't | Why |
|-------|-----|
| Facts derivable from code/config | Agent can read `tsconfig.json`, `package.json` |
| Marketing prose | "Our world-class platform..." — wastes tokens |
| Duplicate of README content | Reduces task success — every line should be agent-specific |
| Soft directives ("consider doing X") | Not falsifiable, ignored |
| Wiki links instead of inline commands | Agents don't browse wikis |

### How to Write Rules That Work

- **Falsifiable:** "All async functions must have a timeout" ✅ — "Write good code" ❌
- **Every "don't" has a "do":** Provide the replacement. Files with 15+ consecutive
  "don't" rules cause agents to become overly cautious.
- **Capture decisions, not behaviors:** "We use strict mode because we got burned
  by an `any` cascade in Q3 2024" — the agent can't infer this from config.

### Multi-Tool Alignment

If you use Claude Code + Copilot + Cursor, one source of truth:

```
AGENTS.md          # Canonical (cross-tool)
CLAUDE.md          # Contains "@AGENTS.md" + Claude-specific only
.cursor/rules/     # Symlink or thin wrapper to AGENTS.md
```

Manual cross-file maintenance is the failure mode that kills most multi-tool setups.

### Maintenance Rhythm

1. **Update in the same PR.** When you add a new command or change a convention,
   update AGENTS.md immediately. Cost: 2 minutes.
2. **Treat as production code.** Changes go through PR review.
3. **Wire into CI.** A script that parses the command table and runs each on a
   fresh checkout catches drift fast.
4. **Quarterly review.** The file drifts even when you're not editing it.
5. **Test it.** Run a fresh agent session with no context, give it a small task.
   If the agent reads the file and follows the rules, it's working.
6. **Don't auto-generate.** LLM-generated AGENTS.md files slightly reduced
   success and increased cost by 23%. Human-written files perform better.

### Workflow Checklists

The single most effective pattern: numbered multi-step workflows.

```markdown
## Adding a new integration
1. Create config in `integrations/`
2. Register in `lib/registry.ts`
3. Add unit tests to `tests/integrations/`
4. Update `docs/supported-integrations.md`
5. Run `npm run validate-integrations`
6. Submit PR with `feat(integration): add <name>`
```

This reduced incomplete PRs from **40% → 10%** in one case study.

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Too long (>250 lines) | Split into index + reference docs |
| Soft directives | Make every rule hard or delete it |
| Stale commands | CI validation |
| No do-not-touch list | Agents edit generated code → build breaks |
| Duplicating README | Every line should be agent-specific |
| Auto-generating the file | Human-written outperforms LLM-generated |

---

## OKF Bundle: The Cross-Repo Knowledge Graph

### What It Is

A directory of markdown files with YAML frontmatter, following the Google OKF
standard. One concept = one file. Markdown links create the knowledge graph.
`index.md` files provide progressive disclosure.

### The Core Insight

AI agents don't get bored, don't forget to update cross-references, and can
touch 15 files in one pass — exactly the maintenance burden that causes humans
to abandon wikis. OKF is designed for agent-maintained knowledge.

### Sizing Principles

- **Concept files: 15-30 lines each.** Anything longer signals too many concepts
  in one file.
- **Index files: just the listing + one-sentence descriptions.** The AI uses
  these for discovery, then drills into concepts.
- **log.md: one line per change.** Appended chronologically. The sync process
  reads from the last synced entry.

### Knowledge That Belongs in OKF

| Put in OKF | Don't put in OKF |
|------------|------------------|
| What services exist and their responsibilities | How to run them locally (that's AGENTS.md) |
| What events fire and who listens | Build commands (that's AGENTS.md) |
| Business term → technical entity mappings | Code style rules (that's AGENTS.md) |
| API contracts and auth patterns | Test procedures (that's AGENTS.md) |
| Entity relationships and data ownership | Git workflow (that's AGENTS.md) |

**Rule of thumb:** OKF = what the platform IS. AGENTS.md = how to WORK on it.

### Maintenance Patterns

#### Pattern 1: Log-Driven Sync (recommended)

```
Dev appends to log.md → runs sync command → AI updates concept files
```

Cost: 1 line of text. AI reads only changed files. Proven pattern from Google's
reference implementation.

#### Pattern 2: Periodic Agent Lint

Schedule an agent to crawl the OKF weekly. It checks for:
- Broken internal links (stubs you meant to fill)
- Contradictions between concept files
- Concepts referenced but not yet documented
- Stale information (timestamps older than X months)

This is exactly the work LLMs excel at — tedious cross-referencing humans won't do.

#### Pattern 3: Two-Pass Enrichment

From Google's reference implementation:
- **Pass 1:** Walk data sources, draft concept documents from metadata
- **Pass 2:** LLM crawls authoritative documentation, enriches each concept
  with citations, schemas, and business context

### Link Management

OKF deliberately **tolerates broken links** — they represent "knowledge not yet
written." This is by design. Don't block on completeness. A stub is better than
nothing; a broken link is a placeholder.

But periodically (Pattern 2 above), review them and fill the important ones.

### Versioning

OKF bundles live in git. Benefits:
- Diffable, reviewable, branchable
- Inherits git's access control
- No proprietary database or platform
- `git clone` is the only "deployment"
- Roll back bad updates instantly

### What to Measure

| Metric | What good looks like |
|--------|---------------------|
| Log-to-sync latency | Entries synced within the same day |
| Broken link count | Trending down over time |
| Concept file staleness | No file older than 3 months unreviewed |
| AI hallucination rate | Specs referencing non-OKF concepts trending down |
| Sync cost | 1-3 files updated per feature (not whole bundle) |

---

## AGENTS.md + OKF: How They Relate

```
┌─────────────────────────────────────────────┐
│  OKF (spec-drive repo)                      │
│  What the platform IS                       │
│  - Services, events, glossary, APIs         │
│  - Cross-repo knowledge graph               │
│  - Consumed by: /speckit.specify, explore   │
└──────────────┬──────────────────────────────┘
               │  synced from
               ▼
┌─────────────────────────────────────────────┐
│  AGENTS.md (each service repo)              │
│  How to WORK on this service                │
│  - Build, test, architecture, boundaries    │
│  - Source of truth for OKF sync             │
│  - Consumed by: /speckit.implement, plan    │
└─────────────────────────────────────────────┘
```

AGENTS.md is the **source**. OKF is the **aggregated view**. The sync flow:
AGENTS.md changes → dev runs sync → OKF concept files updated → log.md appended.

---

## Sources and Further Reading

- [AGENTS.md Spec (2026): Recommended Sections](https://www.morphllm.com/agents-md-guide)
- [CLAUDE.md Best Practices, 2026](https://dev.to/0xmariowu/claudemd-best-practices-2026-1i5a)
- [One AGENTS.md for every coding agent](https://dev.to/mudassirworks/one-agentsmd-for-every-coding-agent-stop-maintaining-claudemd-and-geminimd-separately-34g4)
- [Google OKF Announcement](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing)
- [Google's OKF is just Markdown in folders (and that's the point)](https://dev.to/hjarni/googles-open-knowledge-format-is-just-markdown-in-folders-and-thats-the-point-4gnc)
- [OKF: The missing layer between AI agents and real work context](https://www.remio.ai/post/google-s-okf-is-the-missing-layer-between-ai-agents-and-real-work-context)
- [Google OKF reference implementation](https://github.com/GoogleCloudPlatform/knowledge-catalog)
- [wiki-viva-kit: Living operational wiki with agent linting](https://github.com/kimlage/wiki-viva-kit)
