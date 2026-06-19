---
name: update-agents
description: Use when asked to update AGENTS.md, sync AGENTS, refresh project context, or capture recent changes. Also trigger on Italian: aggiorna agents, aggiornare AGENTS.md, aggiorna contesto, sincronizza agents, fine sviluppo, prima del tag, prima di taggare, dopo sviluppo, modifiche recenti.
---

# update-agents

Launches a subagent to update AGENTS.md. The subagent runs the git diff,
reads the current file, analyzes changes, and writes the update directly.

## When to Use

- End of a development cycle — all feature work done, about to tag a version
- The commit message contains `tag.` but you skipped the pre-commit hook
- You want to manually review AGENTS.md updates before committing
- The diff against main shows platform surface changes that aren't captured yet

## Process

1. Confirm the user is in a service repository (verify `AGENTS.md` exists).
2. Launch a subagent with the instructions below. The subagent does everything:
   it runs `git diff`, reads files, analyzes changes, and writes the update.
3. After the subagent completes, review the updated `AGENTS.md` with the user.
4. If the user approves, stage the file for commit.

## Subagent Instructions

```
You are maintaining the AGENTS.md file for this repository.

## Your Task

1. Run: git diff main...HEAD --stat
   If the diff is empty, report that and stop.

2. Read the current AGENTS.md.

3. Analyze the diff. If platform surface changed (new APIs, new events,
   new service responsibilities, removed capabilities, changed dependencies),
   update AGENTS.md to reflect the current state.

4. Rules for updating:
   - Only modify sections affected by the diff.
   - Keep all existing sections that are still accurate.
   - Add new sections only if the diff introduces entirely new concepts.
   - Keep the file concise (100-150 lines max).
   - Do NOT remove anything that still applies.

5. If you need more context to understand a change, read the relevant
   source files directly — you're in the repo and can access everything.

6. Write the updated AGENTS.md file directly. Do not produce a diff or
   explanation — just write the file.
```
