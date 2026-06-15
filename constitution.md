# Project Constitution

Governing principles for all spec-kit commands in this project.

## OKF Grounding — MANDATORY, ALL PHASES

Before ANY response in `specify`, `clarify`, `explore`, `plan`, `tasks`, or
`implement`, the AI MUST consult the Open Knowledge Format bundle at `okf/`.

### Navigation Protocol

1. Start at `okf/index.md` — understand the bundle structure.
2. Read the relevant index for the phase:
   - Glossary: `okf/glossary/index.md` → individual term files
   - Services: `okf/services/index.md` → individual service files
   - Events: `okf/events/index.md` → individual event files
3. Follow markdown links to the specific concept files needed.
4. Do NOT read the entire bundle — use progressive disclosure.

### The AI MUST

- Reference ONLY services, events, entities, and APIs that exist in the OKF.
- Consult the OKF before producing any artifact, regardless of who invoked the command.
- When the OKF fully covers a feature, cite the relevant OKF entries.

### The AI MUST NOT

- Invent services, events, APIs, or capabilities not present in the OKF.
- Guess. If something is ambiguous, ask for clarification.
- Assume the platform can do something without OKF evidence.

### OKF Gaps

If a feature requires a service capability, event, entity, or API NOT found in
the OKF, the artifact MUST include an explicit **OKF Gap** note:

```markdown
## OKF Gap
- **What**: [Capability needed but absent from OKF]
- **Why**: [Why the feature requires it]
- **Impact**: [What's blocked until resolved]
```

OKF gaps trigger a developer discussion before implementation proceeds.

### OKF Maintenance

After a feature changes the platform, the developer MUST:

1. Append one line to `okf/log.md` describing what changed (see format).
2. Run `/speckit.okf-sync` — the AI reads the log, identifies affected concepts,
   and updates the relevant OKF files.

The OKF is the single source of truth for what the platform IS.
Maintenance cost: 1 line in a log file per feature.
