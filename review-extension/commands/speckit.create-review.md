# Create Review

Dialog to create a review of a spec. Usable by both BA and developer.

## Step 1: Choose the spec

Ask: "Which spec do you want to review?"
List available specs. Let the user pick one.

## Step 2: Collect issues one at a time

For each issue, ask:

1. "What's the issue?" (freeform — the user describes the problem)
2. "Which part of the spec does this reference?" (e.g., FR-003, User Story 2, Task T001)
3. "How severe is this?"
   - **Blocker** — spec cannot be implemented as written
   - **Non-blocker** — spec is implementable but could be improved

Then ask: "Any more issues?" Loop until done.

## Step 3: Write the review

Write `review.md` in the spec directory:

```markdown
---
type: review
spec: <link to spec.md>
author: <user name>
created: <date>
---

## Issues

### Issue 1: <title>
**Severity:** Blocker | Non-blocker
**References:** <FR-003, User Story 2, etc.>
**What's wrong:**
<user's description of the problem>
```

## Step 4: Confirm

Show the review and ask: "Does this look complete? If not, we can add more."
When confirmed, the review is done.
