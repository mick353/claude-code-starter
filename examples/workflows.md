# Example Workflows

Three concrete workflows showing how the rules, agents, skills, and docs in this starter pack come together. Adapt to your setup.

## 1. New feature, end-to-end

You have a feature request: *"Add email validation to the signup form. Reject obviously bad input client-side; verify on the server too."*

### Phase 1 — Research (Sonnet, search-first skill)

```
"Use search-first. Find:
 - existing email validation in this codebase
 - the signup endpoint and current validation
 - the form component and current validation
 What conventions does the project use for input validation?"
```

Output: a short brief listing files, conventions, and any uncertainties.

### Phase 2 — Plan (planner subagent)

```
"Plan the email validation feature. Use the research above as input.
Write the plan to .claude/plans/email-validation.md and return the path."
```

Output: ordered steps, files to touch, test strategy, risk notes.

### Phase 3 — Implement (Sonnet, tdd-guide subagent or skill)

`/clear` to drop research context. Then:

```
"Read .claude/plans/email-validation.md. Implement Step 1 only,
test-first. Show me the red, green, and refactor for each test."
```

After step 1 passes, repeat for each subsequent step. One step per turn keeps context clean and lets you intervene if the implementation drifts.

### Phase 4 — Review (Sonnet, code-reviewer subagent)

```
"Review the diff since the start of this branch.
Group findings by severity. No need to re-test; I've run the suite."
```

Output: a structured review. Address Critical and Important; consider Suggestions.

### Phase 5 — Security check (Opus, security-reviewer subagent)

```
"Review the same diff for security issues only. Focus on input
validation, secrets, and any auth touchpoints."
```

Output: any security findings with severity, threat, likelihood, and fix.

### Phase 6 — Verify

```bash
npm run lint && npm run typecheck && npm test
```

If all green, commit with conventional-commit format. PR description references the plan file.

### End of session

```
"Summarize this session into .claude/sessions/2026-05-10-email-validation.md
following the strategic-compact format. Then I'll review and edit."
```

You edit the summary, save, `/clear`. Tomorrow's continuation starts from that file.

---

## 2. Bug fix from a vague report

The report: *"Sometimes the dashboard takes 30 seconds to load. Can't reproduce reliably."*

### Phase 1 — Investigate (Opus, no subagent)

This is the kind of investigation that benefits from the orchestrator's full context. Don't delegate.

```
"Vague performance bug. Help me investigate.
- What endpoints does the dashboard call?
- What might be slow but only sometimes?
- What instrumentation do we have?"
```

Read the dashboard component, trace the data flow, identify possible culprits.

### Phase 2 — Hypothesis (Sonnet, with you)

State the leading hypothesis explicitly:

> *"I suspect the `/api/metrics` endpoint occasionally hits a cold cache and reruns the aggregation query, which is unindexed. Check: is there a query plan we can EXPLAIN, and do we have any logs from slow requests?"*

Confirm or refute with evidence (logs, EXPLAIN output, profiling). If confirmed, you have a real bug to fix; if refuted, hypothesize again.

### Phase 3 — Reproduce (Sonnet)

```
"Write a test that triggers the slow path deterministically.
The test should fail (be slow / time out) before the fix
and pass after."
```

The regression test is the receipt that proves the fix works.

### Phase 4 — Fix and verify (tdd-guide-style)

Implement the fix. Run the regression test. Run the full suite. Run the lint/type/test gate.

### Phase 5 — Document and commit

Commit message: `fix(api): index metrics aggregation query to fix dashboard timeouts`

Body explains the symptom, the root cause, and what changed.

---

## 3. Pre-production pre-flight checklist

Before deploying a non-trivial change to production, run this sequence. Quick and catches a lot.

### Step 1 — Lint, type, test

```bash
npm run lint && npm run typecheck && npm test
```

If any fail, stop. Fix before continuing.

### Step 2 — Refactor cleaner (Sonnet, refactor-cleaner subagent)

```
"Run the refactor-cleaner agent on the changes in this PR.
Look for: console.log, debug code, stale comments, dead code,
new dependencies."
```

Address Critical findings. Document any deferred items in the PR description.

### Step 3 — Security review (Opus, security-reviewer subagent)

```
"Run security-reviewer on this PR. Focus on any new
input handling, auth code, or external API calls."
```

Address findings.

### Step 4 — Code review (Sonnet, code-reviewer subagent)

```
"Run code-reviewer on this PR. Focus on the things humans miss
on self-review: edge cases, error paths, weak tests."
```

### Step 5 — Manual smoke

Run the change locally, click through the happy path, and one error path. AI reviews catch a lot but not "the dropdown is misaligned on Safari."

### Step 6 — Deploy with rollback ready

If the deploy is non-trivial, have the rollback command ready in another terminal *before* you press deploy. Practiced rollback is calm rollback.

---

## What these examples have in common

- **Phases are explicit.** Research, plan, implement, review, verify. Each has a defined input and output.
- **`/clear` between phases.** The orchestrator doesn't carry exploration context into implementation context.
- **Subagents are specialists.** The right model and the right scope for each task.
- **Verification is concrete.** A test, a quality gate command, or a real review — not "looks good to me."
- **State persists.** Plan files in `.claude/plans/`, session files in `.claude/sessions/`. Tomorrow-you doesn't need to rebuild today's state from memory.

These workflows are templates. The specifics — what model, which subagent, how many phases — adapt to the task. The discipline of *having* phases, with *defined* deliverables, generalizes.
