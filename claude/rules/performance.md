# Performance (Claude Code workflow)

This file is about Claude Code workflow performance — context, tokens, model selection — not application runtime performance.

## Model selection

Default to **Sonnet** for coding work. Adjust:

- **Haiku** for: file search, simple edits, doc generation, mechanical transformations
- **Opus** for: architecture, hard bugs, security reviews, structural refactors (5+ files)

If a Sonnet attempt fails twice on the same task, escalate to Opus and re-plan rather than retrying.

See `docs/model-selection.md` for the full matrix.

## Context discipline

- **Disable unused MCPs** before starting a session. `/mcp` lists what's enabled.
- **Keep CLAUDE.md under ~150 lines.** Detailed standards belong in rules/, loaded on demand or as a small fixed set.
- **Auto-loaded skills:** under 5 at any one time. Other skills are invocable but not always-loaded.
- **Total active tools:** under 80 across all enabled MCPs and built-in tools.

If Claude is "getting dumber" mid-session, the cause is almost always context bloat, not the model.

## Compaction

- Disable auto-compact for multi-step reasoning sessions where you don't want intermediate state flattened.
- Manually `/compact` at logical boundaries: after research/before implementation, after implementation/before review.
- Take `/checkpoints` before risky operations.

## MCP vs CLI

If an MCP is mostly wrapping a CLI (GitHub, Supabase, Vercel, Railway), prefer:

```
remove the MCP from active set → invoke the CLI through Bash tool
+ a small project skill that documents flag conventions
```

You recover the context the MCP was eating without losing meaningful capability. Keep MCPs that genuinely add capability the CLI doesn't have (live HTTP, stateful sessions, no-CLI services, browser control).

## Sessions over single conversations

For work spanning multiple days, write a session summary at end and load it at start. See `docs/memory-persistence.md`. The cost is 5 minutes per session; the saving is not having to re-derive yesterday's state.

## Parallelization

- Default: one Claude instance.
- Add a second only when the second task is genuinely independent.
- Past three instances, your own attention is the bottleneck.
- Use git worktrees if any two instances might touch the same files.

See `docs/parallelization.md`.

## When to spend, when to save

- **Spend tokens** on: planning, deliberate verification, code review of finished work, the first attempt at unfamiliar problems.
- **Save tokens** on: file search, mechanical edits, generating routine docs, anything you've done a hundred times.

The aggregate cost of being too cheap (rework, bugs, wasted iterations) often exceeds the model premium on hard tasks. The aggregate cost of being too expensive (Opus on grep) compounds across a workday. Calibrate.
