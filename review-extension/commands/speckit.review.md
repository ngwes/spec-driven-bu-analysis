# Resolve Review

Dialog to resolve review issues against a spec. Produces a new spec version.
The original spec is NEVER modified.

## Step 1: Choose the spec

Ask: "Which spec are you resolving reviews for?"
List available specs. Let the user pick one.

## Step 2: Gather reviews

Ask: "Which review files should I apply?"
List review files in the spec directory (or let the user specify paths).
Multiple reviews can be applied at once.

## Step 3: Resolve issues one at a time

Read the spec and all gathered reviews. For each issue (ordered by severity,
blockers first):

1. Present the issue:
   > "Issue: FR-003 retry logic conflicts with platform constraint"
   > "The Notification service has no retry capability. The spec says retry 3 times."
   > "Options:"
   > "A) Keep the requirement — flag as OKF gap"
   > "B) Change to single-attempt + immediate alert"
   > "C) Something else — describe"

2. Let the user decide. Update the spec accordingly.

3. Move to the next issue.

## Step 4: Write the new spec

When all issues are resolved, write a NEW spec file. The original is untouched.

File naming: `spec-v2.md`, `spec-v3.md`, etc. (increment the version).

Frontmatter of the new spec:
```yaml
---
version: 2
previous: <link to previous spec.md or spec-vN.md>
resolved-reviews:
  - <link to review.md>
created: <date>
---
```

The body is the updated spec with all resolutions applied.

## Step 5: Mark reviews as resolved

For each review file applied, append to the review frontmatter:
```yaml
resolved-by: <link to new spec>
resolved-at: <date>
```

## Step 6: Confirm

Present the new spec. "Here's the updated spec. It links back to the original.
Does this look right?"

If changes needed, continue the dialog.
If confirmed, the review loop is closed.
