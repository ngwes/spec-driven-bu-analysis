# BA-Friendly Spec Kit Preset

Makes `/speckit.specify` and `/speckit.clarify` conversational for business analysts.

## What It Changes

- **`/speckit.specify`** — The AI asks one question at a time, dialoguing with the BA
  until the feature is fully described. Then produces the final spec.md.
- **`/speckit.clarify`** — The AI works through ambiguities one by one, updating the
  spec incrementally.

## What It Doesn't Change

- Core spec-kit templates are untouched (wrap strategy).
- Plan, Tasks, Implement phases are unchanged — developers work as normal.
- No new sections added to spec.md.

## Installation

```bash
specify preset add --dev ./ba-friendly
```

## Strategy

Uses `wrap` strategy — conversational instructions are added before the stock
command behavior. When GitHub updates spec-kit's core commands, those updates
flow through underneath.

## Compatibility

- Requires spec-kit (github/spec-kit)
- Agent: Claude Code (or any agent that supports spec-kit slash commands)
